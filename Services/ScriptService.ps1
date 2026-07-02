Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

function Get-TousLesChamps {
    param (
        [string]$Texte
    )

    $resultats         = @() #Tableau vide qui va stocker toutes les paires Question/Réponse
    $lignes            = $Texte -split "\r?\n" # Découpe le texte en tableau de lignes
    $question_courante = $null
    $reponses          = @()

    foreach ($ligne in $lignes)
    {
        $ligne = $ligne.Trim()
        if ([string]::IsNullOrWhiteSpace($ligne)) # si la ligne est vide ou ne contien rien alors on continue 
        { 
            continue
        }

        if ($ligne -match "^(.+?)\s*:\s*(.*)$")
        {
            
            if ($null -ne $question_courante) # si on a deja une question en cours, on la sauvegarde dans le tableau et on y ajoute " | " à ces réponse
            {
                $resultats += [PSCustomObject]@{
                    Question = $question_courante
                    Reponse  = ($reponses -join " | ")
                }
            }

            $question_courante = $Matches[1].Trim() #Capture la question avec la réponse
            $reponses = @() # remet à nouveau pour une nouvell question

            if ($Matches[2].Trim() -ne "") # si sur la meme ligne il y a une réponse alors prend la réponse aussi 
            {
                $reponses += $Matches[2].Trim()
            }
        }
        elseif ($null -ne $question_courante)
        {
            # prend en compte si il y a un titre de section avec une ligne courte sans : et pas de chiffre au debut
            if ($ligne -match "^[A-ZÀ-Ÿ][^:]+$" -and $ligne.Length -lt 30 -and $ligne -notmatch "^\d")
            {
                $resultats += [PSCustomObject]@{
                    Question = $question_courante
                    Reponse  = ($reponses -join " | ")
                }
                $question_courante = $null
                $reponses          = @()
            }
            else
            {
                # Pour les suite de réponses
                $reponses += $ligne
            }
        }
    }

   
    # ligne qui pour  une question sans réponse ("Question : ")
    if ($null -ne $question_courante)
    {
        $resultats += [PSCustomObject]@{
            Question = $question_courante
            Reponse  = ($reponses -join " | ")
        }
    }

    return $resultats #Retourne tout les champs de question réponse.
}

 <#
function Show_last_status {
    param(
        [System.Windows.Forms.Label]$Label,
        [string]$Message,
        [string]$Color
    )

    $Label.Text = $Message
    $Label.ForeColor = [System.Drawing.Color]::FromName($Color)
    $Label.Visible = $true


}

function Show-Status {
    param(
        [System.Windows.Forms.Label]$Label,
        [string]$Message,
        [string]$Color
    )

    $Label.Text = $Message
    $Label.ForeColor = [System.Drawing.Color]::FromName($Color)
    $Label.Visible = $true
    $Label.Refresh()

    Start-Sleep -Seconds 3

    $Label.Visible = $false 

} #>
# Affiche une boîte de dialogue d'erreur
function Show-Error {
    param(
        [string]$text
    )

    [System.Windows.Forms.MessageBox]::Show(
        "$text",
        "Erreur",
        "OK",
        "Error"
    )

}

# Affiche une boîte de dialogue d'information
function Show-Information {
    param(
        [string]$text
    )
    [System.Windows.Forms.MessageBox]::Show(
        "$text",
        "Information",
        "OK",
        "Information"
    )

}
# Affiche une boîte de dialogue d'avertissement
function Show-Warning {
    param(
        [string]$text
    )
    [System.Windows.Forms.MessageBox]::Show(
        "$text",
        "Warnings",
        "OK",
        "Warning"
    )
}