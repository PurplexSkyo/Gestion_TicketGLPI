function Start-SearchTicket
{
    param(
        [string]$TicketID

    )

    $Document = [System.Environment]::GetFolderPath("MyDocuments")
    $DossierExport = Join-Path $Document "Ticket_GLPI"
    $CheminDossier = Join-Path $DossierExport "dossier_ID_$TicketID"
    $CheminFichier = Join-Path $CheminDossier "Ticket_$TicketID.csv"

    # Vérifie que le fichier CSV du ticket existe
    if (-not(Test-Path $CheminFichier))
    {
        $a = Show-Error "Le fichier CSV est introuvable pour le ticket : $TicketID"
        Write-Log "Le fichier CSV est introuvable dans le fichier"
        return $null
    }



    return $CheminFichier
}

function Start-ExecutionCSV
{
    param(
        [string]$ticket,
        $textbox_sans_txt
    )
    #Vérifie qu'un script a été sélectionné
    if (-not $script:scriptSelectionne) 
    {
        $a = Show-Error "Aucun script sélectionné."
        Write-Log "Aucun fichier sélectionné"
        return
    }

        #Vérifie qu'un numéro de ticket a été saisi
    if ([string]::IsNullOrWhiteSpace($ticket)) 
    {
        $p = Show-Error "Saisissez d'abord le ticket"
        Write-Log "Aucun ticket entré, entrer un ticket pour continuer "
        return
    }

    try {

        $cheminCsv = Start-SearchTicket -TicketId $ticket
        if ($cheminCsv )
        {
            Write-Log "CSV trouvé : $cheminCsv" 

            $nomScript = [System.IO.Path]::GetFileNameWithoutExtension($script:scriptSelectionne)

            $CheminDossier = Split-Path -Path $cheminCsv -Parent
            $fichierLog = Join-Path $CheminDossier "${nomScript}_${ticket}_log.log"

             #lance le script sélectionné en lui passant le CSV et le fichier de log
            Write-Log "Ouverture de l'invite de commande"
            $process = Start-Process pwsh.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($script:scriptSelectionne)`" `"$cheminCsv`" `"$fichierLog`"" -PassThru -Wait

             #Ajoute un résumé de l'exécution dans le fichier de log
        @"
Date : $(Get-Date)
Ticket : $ticket
Script : $script:scriptSelectionne
CSV utilisé : $cheminCsv
Log : $fichierLog
Code retour : $($process.ExitCode)
"@ | Add-Content $fichierLog -Encoding utf8BOM

        Show-Information "Exécution terminée.`nLog : $fichierLog`nCode retour : $($process.ExitCode)"
        Write-Log "Exécutions terminée"
        }

    }
    catch 
    {
        Write-Log "Erreur : $($_.Exception.Message)" 
        Show-Error "Erreur :$($_.Exception.Message)"
    }

    # Réinitialise la zone de saisie
    $textbox_sans_txt.Text = ""
    $textbox_sans_txt.Focus()
}