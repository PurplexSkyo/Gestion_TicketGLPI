Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()


$Global:Logs = @()
$Global:LogTextBox = $null

function Add-Log {
    param([string]$Message)

    $logLine = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $Message

    # Historique complet
    $Global:Logs += $logLine

    # Mise à jour en temps réel si la fenêtre est ouverte
    if ($Global:LogTextBox -ne $null) 
    {
        $Global:LogTextBox.AppendText($logLine + "`r`n")
        $Global:LogTextBox.SelectionStart = $Global:LogTextBox.Text.Length
        $Global:LogTextBox.ScrollToCaret()
    }
}


#Fenêtre de connextion 
$page_de_connection = New-Object System.Windows.Forms.Form
$page_de_connection.Text = "Connexion"
$page_de_connection.FormBorderStyle = 'FixedDialog'
$page_de_connection.StartPosition = 'CenterScreen'
$page_de_connection.Size = New-Object System.Drawing.Size(500,400)
$page_de_connection.BackColor = [System.Drawing.Color]::Gainsboro
$page_de_connection.TopMost = $true 



#Label de description
$label_description = New-Object System.Windows.Forms.Label
$label_description.Text = "Saisissez l'user-token et l'app-token."
$label_description.Font = New-Object System.Drawing.Font("Segoe UI",12)
$label_description.Location = New-Object System.Drawing.Point(50,80)
$label_description.AutoSize = $true
$page_de_connection.Controls.Add($label_description)



#Coté User | Label de connexion
$user_connexion = New-Object System.Windows.Forms.Label
$user_connexion.Text = "Jeton d'API :"
$user_connexion.Font = New-Object System.Drawing.Font("Segoe UI",14)
$user_connexion.AutoSize = $true
$user_connexion.Location = New-Object System.Drawing.Point(50,120)
$page_de_connection.Controls.Add($user_connexion)



#Coté User  | Textbox de connexion
$user_textbox = New-Object System.Windows.Forms.TextBox
$user_textbox.Size = New-Object System.Drawing.Size (200,25)
$user_textbox.Location = New-Object System.Drawing.Point(180, 125)
$user_textbox.UseSystemPasswordChar = $true
$page_de_connection.Controls.Add($user_textbox)

#Coté User | Help bouton
$help_user_btn = New-Object  System.windows.Forms.Button
$help_user_btn.Text = "?"
$help_user_btn.Font = New-Object System.Drawing.Font('Arial',13,[System.Drawing.FontStyle]::Bold)
$help_user_btn.AutoSize = $true
$help_user_btn.Size = New-Object System.Drawing.Size(10)
$help_user_btn.Location = New-Object System.Drawing.Point(20,115)
$page_de_connection.Controls.Add($help_user_btn)

$help_user_btn.Add_Click(
    {
        [System.Windows.Forms.MessageBox]::Show(
            @"
Où le trouver ?

1. Cliquez sur votre profil
2. Allez dans "Mes préférences"
3. Descendez jusqu'à la section API
4. Copiez votre jeton API

(Si le champ est vide, cochez "Régénérer" puis enregistrez pour en générer un nouveau.)
"@,
            "Aide sur user token",
            "OK",
            "Information"
        )
    }
)




#Cote App-Token | Label de connexion 
$app_label = New-Object System.Windows.Forms.Label
$app_label.Text = "App-Token  :"
$app_label.Font = New-Object System.Drawing.Font("Segoe UI",14)
$app_label.AutoSize = $true
$app_label.Location = New-Object System.Drawing.Point(50,160)
$page_de_connection.Controls.Add($app_label)



#Coté App-Token |Textbox de connexion
$app_textbox = New-Object System.Windows.Forms.TextBox
$app_textbox.Size = New-Object System.Drawing.Size (200,25)
$app_textbox.Location = New-Object System.Drawing.Point(180, 165)
$app_textbox.UseSystemPasswordChar = $true
$page_de_connection.Controls.Add($app_textbox)


#Coté App-Token | Help button
$help_app_btn = New-Object  System.windows.Forms.Button
$help_app_btn.Text = "?"
$help_app_btn.Font = New-Object System.Drawing.Font('Arial',13,[System.Drawing.FontStyle]::Bold)
$help_app_btn.AutoSize = $true
$help_app_btn.Size = New-Object System.Drawing.Size(10)
$help_app_btn.Location = New-Object System.Drawing.Point(20,160)
$page_de_connection.Controls.Add($help_app_btn)



$help_app_btn.Add_Click(
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Veuillez contacter un administrateur afin d’obtenir l’App-Token nécessaire à l’utilisation de l’API REST GLPI.",
            "Aide sur app token",
            "OK",
            "Information"
        )
    }
)


#Le Boutton valider
$validation_both = New-Object System.Windows.Forms.Button
$validation_both.Text = "Valider"
$validation_both.Cursor = 'Hand'
$validation_both.Font  = New-Object System.Drawing.Font('Geogia',11)
$validation_both.Size = New-Object System.Drawing.Size(90,35)
$validation_both.Location = New-Object System.Drawing.Point(190,210)
$page_de_connection.Controls.Add($validation_both)



$Script:app   = $app_textbox.Text
$Script:jeton_api = $user_textbox.Text

$page_de_connection.AcceptButton = $validation_both

#Le bouton quitter
$button_leave_page_connexion = New-Object System.Windows.Forms.Button
$button_leave_page_connexion.Text = "Quitter"
$button_leave_page_connexion.Size = New-Object System.Drawing.Size(80,35)
$button_leave_page_connexion.Location = New-Object System.Drawing.Point(390,310)
$button_leave_page_connexion.DialogResult = 'Cancel'
$button_leave_page_connexion.Cursor = 'Hand'
$button_leave_page_connexion.Font  = New-Object System.Drawing.Font('Georgia',11)
$page_de_connection.CancelButton= ($button_leave_page_connexion)
$page_de_connection.Controls.Add($button_leave_page_connexion)


$validation_both.Add_Click({

    $app = $app_textbox.Text
    $token = $user_textbox.Text

    if ([string]::IsNullOrWhiteSpace($app) -or [string]::IsNullOrWhiteSpace($token)) 
    {
        [System.Windows.Forms.MessageBox]::Show(
            "l'App Token ou Jeton d'API sont vide",
            "Erreur",
            "OK",
            "Warning"

        )
        return
    }

    if ($token.Length -ne 40) 
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Le Jeton d'API ne doit contenir que 40 caractères",
            "Erreur",
            "OK",
            "Warning"
        )
        return
    }
    if($app.Length -ne 40)
    {
        [System.Windows.Forms.MessageBox]::Show(
        "L'App-Token ne doit contenir que 40 caractères",
        "Erreur",
        "OK",
        "Warning"
        )
        return
    }


    $page_de_connection.Tag = @{
        App   = $app
        Token = $token
    }

    $page_de_connection.DialogResult = "OK"
    $page_de_connection.Close()
})


$result = $page_de_connection.ShowDialog()

if ($result -ne "OK")
{
     exit 
}

$app = $page_de_connection.Tag.App
$jeton_api = $page_de_connection.Tag.Token


# $UserToken = $jeton_api #Api qui te permet de te connect sans passez par le loggin/password 
# $AppToken = $app #Un chemin optionnel pour filtré les acces de l'API



$UrlApi ="https://vml-glpi-t.ghu-paris.fr/apirest.php"  #Lien de l'API GLPI du GHU de Paris

$UserToken = "3yYTzjOPdQnGtChwDLNl343ZqcuvfgzG3HvnhV6w" #Api qui te permet de te connect sans passez par le loggin/password 
$AppToken = "TN9JKKwKbV8IykaSmnNvzxtwrpJUGm7qzqPzUeww" #Un chemin optionnel pour filtré les acces de l'API


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

}

$chargement_message = New-Object System.Windows.Forms.Form
$chargement_message.Text = "Information"
$chargement_message.Size = New-Object System.Drawing.Size(300,100)
$chargement_message.StartPosition = "CenterScreen"
$chargement_message.ControlBox = $false

$label_de_chargement = New-Object System.Windows.Forms.Label
$label_de_chargement.Text = "En attente de connexion"
$label_de_chargement.AutoSize = $true
$label_de_chargement.Location = New-Object System.Drawing.Point(70,20)
$chargement_message.Controls.Add($label_de_chargement)

$headers = @{
    "App-Token"     = $AppToken
    "Authorization" = "user_token $UserToken"
    "Content-Type"  = "application/json"
}

$chargement_message.Show()
[System.Windows.Forms.Application]::DoEvents() 

try {
    
    $answer = Invoke-RestMethod -Uri "$UrlApi/initSession" -Method Get -Headers $headers # Initialisation de la session
    $chargement_message.Close()
    $SessionToken = $answer.session_token
    
    

    if ($SessionToken)
    {
        [System.Windows.Forms.MessageBox]::Show(
            "Connexion réussi`nSession_token : $SessionToken",
            "Trouvé",
            "OK",
            "Information"
        )
        Add-Log "Connexion reussie"
    }
    elseif(-not $SessionToken)
    {
    [System.Windows.Forms.MessageBox]::Show(
        "Session_token est invalide, veuillez relancer votre application.",
        "Error",
        "OK",
        "Error"
    )
    exit
}
}
catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Connexion invalide `nVeuillez ressayez.",
        "Erreur",
        "OK",
        "Warning"
    )
    exit
}





$Session_token_header = @{
    "App-Token"     = $AppToken
    "Session-Token" = $SessionToken
    "Content-Type"  = "application/json"
}



#Interface utilisateur principale : la fenetre
$fenetre = New-Object System.Windows.Forms.Form
$fenetre.Text = "Test interface windows"
$fenetre.Width = 500
$fenetre.Height = 400
$fenetre.StartPosition = 'CenterScreen'
$fenetre.FormBorderStyle = 'FixedDialog'
$fenetre.TopMost = $true 



#Le label qui pose la question pour l'id du ticket
$label_question = New-Object System.Windows.Forms.Label
$label_question.Text = "Saisie l'id du ticket : "
$label_question.AutoSize = $true
$label_question.Location = New-Object System.Drawing.Point(50,120)


#Cela nous permet de saisir le num du ticket
$textbox_num = New-Object System.Windows.Forms.TextBox
$textbox_num.MaxLength = 6 #Peut rentrer que 6 caractères
$textbox_num.Location = New-Object System.Drawing.Point(50,140)
$textbox_num.Width = 150

#Le bouton valide
$button_valide_num = New-Object System.Windows.Forms.Button
$button_valide_num.Text = "Télécharger CSV"
$button_valide_num.Location = New-Object System.Drawing.Point(210,130)
$button_valide_num.Cursor = 'Hand'
$button_valide_num.Size = New-Object System.Drawing.Size(90 , 35)


$status_selection_fichier = New-Object System.Windows.Forms.Label
$status_selection_fichier.Text = "Fichier choisis : $fichierSelectionne"
$status_selection_fichier.AutoSize = $true
$status_selection_fichier.Location = [System.Drawing.Point]::new(300, 50)
$fenetre.Controls.Add($status_selection_fichier)

#Bouton parcourir 
$button_pacourrir = New-Object System.Windows.Forms.Button
$button_pacourrir.Text = "Parcourir"
$button_pacourrir.Location = [System.Drawing.Point]::new(350,80)
$button_pacourrir.Cursor = 'Hand'
$button_pacourrir.Size = [System.Drawing.Size]::new(90,35)

$script:scriptSelectionne = $null

$button_pacourrir.Add_Click(
    {

        $Chemin = "$env:USERPROFILE\Documents\Scripts_ps1"


        New-Item -ItemType Directory -Path $Chemin -Force | Out-Null

        $PathUser = [Environment]::GetEnvironmentVariable("Path", "User")

        if ($PathUser -notlike "*$Chemin*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$PathUser;$Chemin",
                "User"
            )
        }

        

        if(Test-Path $Chemin)
        {
            Write-Host "Chemin déjà crée"

        }
        else
        {
            Write-Host "Le dossier C:\Users\natan.poulain\Documents\Scripts_ps1 à été crée et peut selectionner des scripts PS1."
        }
        
        

        #$fichiers = Get-ChildItem $Chemin -Filter "*.ps1"

        $dialog = New-Object System.Windows.Forms.OpenFileDialog
        $dialog.Title = "Selectionner les scripts PS1"
        $dialog.InitialDirectory = "$Chemin"
        $dialog.Filter = "Scripts PowerShell (*.ps1)|*.ps1"
        if ($dialog.ShowDialog() -eq "OK") {

            $script:scriptSelectionne = $dialog.FileName
            $fichier_script = Split-Path $script:scriptSelectionne -Leaf

            $status_selection_fichier.Text = "Fichier choisi : $fichier_script"

            [System.Windows.Forms.MessageBox]::Show(
                "Fichier choisi : $fichier_script"
            )
        
        }
    }
   
)



#Bouton executer
$button_executer = New-Object System.Windows.Forms.Button
$button_executer.Text = "Execute"
$button_executer.Location = [System.Drawing.Point]::new(350,120)
$button_executer.Cursor = 'Hand'
$button_executer.Size = [System.Drawing.Size]::new(90,35)







#Button quitter
$button_quitter = New-Object System.Windows.Forms.Button
$button_quitter.Text  = "Quitter"
$button_quitter.AutoSize = $true
$button_quitter.DialogResult = 'Cancel'
$button_quitter.Location  = New-Object System.Drawing.Point(350 ,  300)
$button_quitter.Cursor = 'Hand'
$button_quitter.Size = New-Object System.Drawing.Size(90 , 35)

#Settings | Bouton des paramètres
$button_settings = New-Object System.Windows.Forms.Button
$button_settings.Text = "Settings"
$button_settings.Location = New-Object System.Drawing.Point(120,300)
$button_settings.Size = [System.Drawing.Size]::new(90,35)




#Settings | Intérieur des paramètres
$setting_tab = New-Object System.Windows.Forms.Form
$setting_tab.Text = "Settings"
$setting_tab.Size = New-Object System.Drawing.Size(300,200)
$setting_tab.FormBorderStyle = 'FixedDialog'





$button_settings.Add_Click(
    {
        $setting_tab.ShowDialog()
    }
)







#Bouton pour voir les logs
$voir_log = New-Object System.Windows.Forms.Button
$voir_log.Text= "Voir les logs"
$voir_log.AutoSize = $true
$voir_log.Cursor = 'Hand'
$voir_log.Size = New-Object System.Drawing.Size(90 , 35)
$voir_log.Location = New-Object System.Drawing.Point(20 ,  300)


$voir_log.Add_Click(
    {
        if ($Global:logForm -ne $null -and -not $Global:logForm.IsDisposed) {
        
                # La ramener au premier plan
                $Global:LogForm.Activate()
                return
            }

        $Global:logForm = New-Object System.Windows.Forms.Form
        $Global:logForm.Text = "Historique des logs"
        $Global:logForm.Size = New-Object System.Drawing.Size(600,500)
        $Global:logForm.StartPosition = "Manual"
        $Global:logForm.Location = New-Object System.Drawing.Point(
            ($mainForm.Location.X + $mainForm.Width),
            $mainForm.Location.Y
        )

        $Global:LogTextBox = New-Object System.Windows.Forms.RichTextBox
        $Global:LogTextBox.Dock = "Fill"
        $Global:LogTextBox.ReadOnly = $true
        $Global:LogTextBox.Font = New-Object System.Drawing.Font("Consolas",10)

       
        $Global:LogTextBox.Text = $Global:Logs -join "`r`n"

        $Global:logForm.Controls.Add($Global:LogTextBox)

        


        $logForm.Add_FormClosed(
            {
            $Global:LogTextBox = $null
            $Global:logForm =$null
        })

        $Global:logForm.Show()
    }
)


#Le label qui sert de status
$label_status = New-Object System.Windows.Forms.Label
$label_status.AutoSize = $true 
$label_status.Location = New-Object System.Drawing.Point(50,165)
$label_status.ForeColor = [System.Drawing.Color]::Gray

#ATTENDRE LE CODE
$Attente_code = New-Object System.Windows.Forms.Label
$Attente_code.AutoSize = $true 
$Attente_code.Location = New-Object System.Drawing.Point(50,165)
$Attente_code.ForeColor = [System.Drawing.Color]::Gray


$button_valide_num.Add_Click(
    {
        $button_valide_num.Enabled = $false

        $Ticket_num = $textbox_num.Text -replace " ", ""

        if ($Ticket_num -match '^[1-9]\d{0,5}$')
        {

            [System.Windows.Forms.MessageBox]::Show(
                "Valeur acceptée : $Ticket_num",
                "Good",
                "OK",
                "Information"
            )

            Add-Log "ticket saisi : $Ticket_num"
            $Url_ticket = "$UrlApi/Ticket/$Ticket_num" 

           
            #$label_status.Text = "Voici le lien utilisé : $Url_ticket"
            Show-Status $label_status "Voici le lien utilisé : $Url_ticket"  -Color "Green"
            Add-Log "Lien utilisé $Url_ticket"
            
           

            $text_resultat = ""           
            try 
            {
                #Cela donne ticket en général
                
                $Attente_code.Visible = $true
                $Attente_code.Text = "Recherche le ticket..."
                $LookingFor = Invoke-RestMethod -Uri $Url_ticket -Method Get -Headers $Session_token_header
                $Attente_code.Visible = $false
                Show-Status $label_status "Ticket Trouvé"  -Color "Green"
                
                
                # Write-Host ""

                # Write-Host "===== CONTENU ====="

                if ($null -ne $LookingFor.content) 
                {
                    # Décode le HTML
                    $les_text = [System.Net.WebUtility]::HtmlDecode($LookingFor.content)

                    # Extrait la question depuis les balises <b> et met un marqueur
                    $les_text = $les_text -replace '(?i)<b>(.*?)</b>', '###QUESTION###$1'

                    # Remplace les <br> par " | " pour garder les réponses multiples sur une ligne
                    $les_text = $les_text -replace '(?i)<br\s*/?>', ' | '

                    # Enlève les balises h1-h6 et les remplace par des retours à la ligne
                    $les_text = $les_text -replace '(?is)<h[1-6][^>]*>(.*?)</h[1-6]>', "`r`n`$1`r`n"

                    # Enlève les autres balises
                    $les_text = $les_text -replace '(?i)</?(?:p|li|div|tr)[^>]*>', ''
                    $les_text = $les_text -replace '<[^>]+>', ''

                    # Enlève les tabulations et &nbsp et les remplace par des espaces
                    $les_text = $les_text -replace '&nbsp;', ' '
                    $les_text = $les_text -replace '[ \t]+', ' '

                    # Affiche pas les numéros
                    $les_text = $les_text -replace '\d+\)\s*', ''

                    # Remet en lignes propres sur le marqueur
                    $les_text = $les_text -replace '###QUESTION###', "`r`n"
                    $les_text = $les_text -replace "(\r?\n){2,}", "`r`n"

                    # Variable des résultats
                    $text_resultat = $les_text.Trim()

                    Write-Host $text_resultat

                    


                }
                else
                {

                    #$label_status.Text = "Le champ content est vide ou absent"
                    $Attente_code.Visible = $false
                    Show-Status $label_status "Le champ content est vide ou absent." "Red"
                    # Vide le TextBox en cas d'erreur
                    $textbox_num.Text = ""
                    $textbox_num.Focus()
                    $button_valide_num.Enabled = $true
                }

            }
            catch 
            {
                $Attente_code.Visible = $false
                $error_message = $_.Exception.Message
                
                Show-Status $label_status "Erreur loRs de la récupération`n$error_message" "Red"

                # Vide le TextBox en cas d'erreur
                $textbox_num.Text = ""
                $textbox_num.Focus()
                $button_valide_num.Enabled = $true
                #Write-Host ""
                #Write-Host "Erreur lors de la récupération du ticket"
                 # Permet de voir en profondeur l'erreur du message

                #Permet de fermé la Sesison
                #$finDeSession = Invoke-RestMethod -Uri "$UrlApi/killSession" -Method Get -Headers $Session_token_header

                #Write-Host "Fin de la session : $finDeSession"
                return
            }
            
            $toutes_les_paires = Get-TousLesChamps -Texte $text_resultat

            if ($toutes_les_paires.Count -eq 0)
            {
                Show-Status $label_status "Aucune paire question/reponse trouvée dans ce ticket" "Red"

                
                # Vide le TextBox en cas d'erreur
                $textbox_num.Text = ""
                $textbox_num.Focus()
                $button_valide_num.Enabled = $true
                return
            }

            #Write-Host "$($toutes_les_paires.Count) paire(s) trouvée(s)."
            #$label_status.Text = "$($toutes_les_paires.Count) paire(s) trouvée(s)."
            Show_last_status $label_status "$($toutes_les_paires.Count) paire(s) trouvée(s)." "Green"

            # Récupère toutes les questions du tableau 
            $questionS = $toutes_les_paires | ForEach-Object {
                $_.Question 
            }
            # Récupère toutes les réponses tu tableau
            $reponseS = $toutes_les_paires | ForEach-Object {
                $_.Reponse 
            }

            $ligne_questions = [PSCustomObject]($questionS | ForEach-Object -Begin { $h = [ordered]@{} } -Process { $h[$_] = $_ } -End { $h })
            $ligne_reponses  = [PSCustomObject]($reponseS  | ForEach-Object -Begin { $h = [ordered]@{}; $i = 0 } -Process { $h[$questionS[$i]] = $_; $i++ } -End { $h })


            $Document = [System.Environment]::GetFolderPath("MyDocuments")

            $DossierExport = Join-Path $Document "Gestion_Ticket_GLPI"


            if (-not (Test-Path $DossierExport)) {
                Show-Status $label_status "Le dossier n'a pas été crée." "Red"
                Show-Status $label_status "Création du dossier $DossierExport" "Green"
                Write-Host "Création du dossier $Dossierexp"
                New-Item -Path $DossierExport -ItemType Directory -Force | Out-Null
                Write-Host "Dossier créé : $DossierExport "
                Show-Status $label_status "Le dossier a été crée $DossierExport." "Green"
            }

            $CheminDossier = Join-Path $DossierExport "dossier_ID_$Ticket_num"

            if (-not(Test-Path $CheminDossier))
            {
                Show-Status $label_status "Création du dossier avec l'ID $Ticket_num" "Green"
                Write-Host "Creation du dossier avec l'id $Ticket_num"
                New-Item -Path $CheminDossier -ItemType Directory -Force | Out-Null
                Write-Host "Dossier crée"
                Show-Status $label_status "Le dossier a été crée dans $DossierExport" "Green"

            }


            $CheminFichier = Join-Path $CheminDossier "Tickets_$Ticket_num.csv"


            #Vérification pour voir si le fichier existe DEJA dans l'emplacement donné
            if (Test-Path $CheminFichier)
            {
                Write-Host "Le fichier existe déjà."
                Show-Status $label_status "Le fichier existe déja." "Red"
                #Invoke-RestMethod -Uri "$UrlApi/killSession" -Method Get -Headers $Session_token_header
                #Write-Host "Fin de la session : $finDeSession"
                $textbox_num.Text = ""
                $textbox_num.Focus()
                $button_valide_num.Enabled = $true 
                
            }
            else
            {
                #Export les question dans un fichier csv dans le chemin donnée,                                   
                (
                $ligne_reponses) | Export-Csv -Path $CheminFichier -NoTypeInformation -Delimiter ";" -Encoding utf8BOM  # delimeter d'avoir une nouvelle ligne à chaque fois. Encoding utf8BOM permet les caractères spéciaux puisse apparaître dans le fichier csv
                
                $textbox_num.Text = ""
                $textbox_num.Focus()
                Write-Host "L'exportation s'est bien passée."
                $button_valide_num.Enabled = $true 

            }



        }
        elseif($Ticket_num -eq "")
        {
            [System.Windows.Forms.MessageBox]::Show(
                "Veuillez entrer l'id du ticket.",
                "Rappel",
                "OK",
                "Information"
            )
             $button_valide_num.Enabled = $true
            # Vide le TextBox en cas d'erreur
            $textbox_num.Text = ""
            $textbox_num.Focus()
        }
        else {

            [System.Windows.Forms.MessageBox]::Show(
                "Veuillez entrer uniquement des chiffres",
                "Erreur",
                "OK",
                "Error"
            )
            $button_valide_num.Enabled = $true
            # Vide le TextBox en cas d'erreur
            $textbox_num.Text = ""
            $textbox_num.Focus()
        }
    }
)





$button_executer.Add_Click(
    {

            if (-not $script:scriptSelectionne) {
                [System.Windows.Forms.MessageBox]::Show("Aucun script sélectionné.")
                return
            }

            $ticket = $textbox_num.Text

            if ([string]::IsNullOrWhiteSpace($ticket)) {
                [System.Windows.Forms.MessageBox]::Show("Aucun ticket saisi.")
                return
            }

        # nom du script sans extens
        $nomScript = [System.IO.Path]::GetFileNameWithoutExtension($script:scriptSelectionne)

        $Document = [System.Environment]::GetFolderPath("MyDocuments")

        $DossierExport = Join-Path $Document "Gestion_Ticket_GLPI"


        if (-not (Test-Path $DossierExport)) 
        {
            Show-Status $label_status "Le dossier n'a pas été crée." "Red"
            Show-Status $label_status "Création du dossier $DossierExport" "Green"
            Write-Host "Création du dossier $Dossierexp"
            New-Item -Path $DossierExport -ItemType Directory -Force | Out-Null
            Write-Host "Dossier créé : $DossierExport "
            Show-Status $label_status "Le dossier a été crée $DossierExport." "Green"
        }

        $CheminDossier = Join-Path $DossierExport "dossier_ID_$ticket"

        if (-not(Test-Path $CheminDossier))
        {
            Show-Status $label_status "Création du dossier avec l'ID $ticket" "Green"
            Write-Host "Creation du dossier avec l'id $ticket"
            New-Item -Path $CheminDossier -ItemType Directory -Force | Out-Null
            Write-Host "Dossier crée"
            Show-Status $label_status "Le dossier a été crée dans $DossierExport" "Green"

        }

      

        

        Start-Transcript -Path $fichierLog -Force

        $PSStyle.OutputRendering = 'PlainText'
        
        try 
        {
        Start-Process -FilePath "pwsh.exe" -ArgumentList @(
            "-NoProfile",
            "-ExecutionPolicy", "Bypass",
            "-NoExit",
            "-File", $script:scriptSelectionne,
            $ticket
        )
        }
        finally 
        {
            Stop-Transcript
        }
        
        $fichierOutput = Join-Path $CheminDossier "${nomScript}_${ticket}_output.txt"
        $fichierLog    = Join-Path $CheminDossier "${nomScript}_${ticket}_log.log"
    
        

        
        @"
Date : $(Get-Date)
Ticket : $ticket
Script : $script:scriptSelectionne
Output : $fichierOutput
"@ | Add-Content $fichierLog -Encoding UTF8

        [System.Windows.Forms.MessageBox]::Show(
            "Exécution terminée.`nOutput : $fichierOutput`nLog : $fichierLog"
        )  

    $textbox_num.Text = ""
    $textbox_num.Focus()
    }
    
)






$fenetre.Controls.AddRange(
    $textbox_num,
    $label_question,
    $button_valide_num,
    $button_quitter,
    $label_status,
    $Attente_code,
    $voir_log,
    $button_settings,
    $button_pacourrir,
    $button_executer

)

$fenetre.ShowDialog() | Out-Null
<#
if ($button_quitter)
{
    $finDeSession = Invoke-RestMethod -Uri "$UrlApi/killSession" -Method Get -Headers $Session_token_header
    Write-Host "Fin de la session : $finDeSession"
}

#>

