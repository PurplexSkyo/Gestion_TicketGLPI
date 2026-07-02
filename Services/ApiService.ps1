
. .\Services\LogService.ps1
. .\Services\SessionService.ps1
. .\Config\Helpers.ps1
. .\Services\ScriptService.ps1

#Function qui exporte le ticket en csv
function Export-Ticket{



    param(
        [hashtable]$The_session_headers,
        [string]$textbox,
        $button,
        [System.Windows.Forms.TextBox]$textbox_sans_txt
    )
    

    $Ticket_ID = $textbox -replace " ","" #Remplace les espace et colle tout les

    
    if ($Ticket_ID -match '^[1-9]\d{0,5}$') 
    {
        $button.Enabled = $false #Désactive le bouton télécarger CSV
        
        
        Write-Log "ID du ticket entré : $Ticket_ID" 
        try 
        {
            Write-Log "Recherche du ticket $Ticket_ID"


            $Url_ticket = "$global:UrlApi/Ticket/$Ticket_ID"#Récupère Le lien complet du ticket


            $LookingFor = Invoke-RestMethod -Uri $Url_ticket -Method Get -Headers $The_session_headers #Cherche le ticket avec le lien
            Write-Log "Ticket $Ticket_ID trouvée"

            if($null -ne $LookingFor.content)
            {

                $texte = [System.Net.WebUtility]::HtmlDecode($LookingFor.content) #Récupère seulement le content du ticket  ( Question / Reponse )

            }
            else
            {
                #Gestion d'erreur 
                Test-EmptyFields -Texte "Contenu du ticket vide" -textebox $textbox
                $button.Enabled = $true
                $textbox_sans_txt.Focus()
                return
            }
        }
        catch
        {   
            Get-ScriptErrors -Texte "Erreur lors de la récupération du ticket" -textebox $textbox
            $button.Enabled = $true
            $textbox_sans_txt.Focus()
            return
        }
        $text_resultat = Clear-TicketContent -Texte $texte #Obtient le ticket nettoyé
        $toute_les_paires =  Get-TousLesChamps -Texte $text_resultat #récupère tout les champs du ticket ( Question / Réponse )
        
        if ($toute_les_paires.Count -eq 0)
        {
            #Gestion d'erreur | Si le ticket n'a aucune pair  (Question / Réponse)
           Get-FieldPairs $Ticket_ID  
            $button.Enabled = $true
            $textbox_sans_txt.Focus()
            return
        }

        Write-Log "$($toute_les_paires.Count) paires trouvées"

        $ligne_to_export = Get-Tables -les_paires $toute_les_paires #Met les Question Réponse par colonne respective

        $Document = [System.Environment]::GetFolderPath("MyDocuments") #Sélectionne globalement le Dossier documents

        $DossierExport = Join-Path $Document "Ticket_GLPI" 

        New-Folder -Chemin $DossierExport #Crée le dossier d'export principal s'il n'existe pas déjà

        $CheminDossier = Join-Path $DossierExport "dossier_ID_$Ticket_ID" #Construit le chemin du dossier dédié au ticket (ex : C:\Exports\dossier_ID_12345)

        New-Folder -Chemin $CheminDossier #Crée le dossier du ticket
        
        $CheminFichier = Join-Path $CheminDossier "Ticket_$Ticket_ID.csv"

        Write-Log "Nouveau fichier crée : $CheminFichier" # Ecris le chemin du fichier 

        #Vérifie si le fichier existe déjà
        if (Test-Path $CheminFichier)
        {
            Write-Log "Exportation Status : Existe déjà"
        }
        else 
        #Export les Question / Réponse en CSV
        {
            $ligne_to_export | Export-Csv $CheminFichier -NoTypeInformation -Delimiter ";" -Encoding utf8BOM
        
        $textbox = ""
        $textbox_sans_txt.Focus()
        Write-Log "Exportation Status : Succès"
        $button.Enabled = $true #Réactive le boutton
        }
    
        
        

    }
    elseif ($Ticket_ID -eq "")
    {
        Write-Log "Mauvaise ID du ticket"
        Show-Error -text "Entrer l'ID du ticket"
        $button.Enabled = $true
        $textbox = ""
        $textbox_sans_txt.Focus() 
        }
    
    else 
    {
        Write-Log "Mauvaise ID du ticket"
        Show-Error -text "Saisissez uniquement des chiffres"
        $button.Enabled = $true
        $textbox = ""
        $textbox_sans_txt.Focus()
    }

}




