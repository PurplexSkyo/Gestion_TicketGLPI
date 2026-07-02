Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
. .\User_Interface\Controls.ps1
. .\Services\ApiService.ps1
. .\User_Interface\Sign_in_UI\Sign_in.ps1
. .\User_Interface\LogForm.ps1
. .\Services\ExecuteServices.ps1
. .\User_Interface\SettingsForm.ps1





[System.Windows.Forms.Application]::EnableVisualStyles()


function Show-MainWindow{

        param(

            [hashtable]$sessionheader
        )
        


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
    $label_question.Location = New-Object System.Drawing.Point(50,60)


    #Cela nous permet de saisir le num du ticket
    $textbox_num = New-Object System.Windows.Forms.TextBox

    $textbox_num.Location = New-Object System.Drawing.Point(50,80)
    $textbox_num.Width = 150


    #Le bouton valide
    $button_download = New-Object System.Windows.Forms.Button
    $button_download.Text = "Télécharger CSV"
    $button_download.Location = New-Object System.Drawing.Point(210,70)
    $button_download.Cursor = 'Hand'
    $button_download.Size = New-Object System.Drawing.Size(90 , 35)



    $status_selection_fichier = New-Object System.Windows.Forms.Label
    $status_selection_fichier.Text = "Fichier choisis : $fichierSelectionne"
    $status_selection_fichier.AutoSize = $true
    $status_selection_fichier.Location = [System.Drawing.Point]::new(50, 160)
    $fenetre.Controls.Add($status_selection_fichier)



    #Bouton parcourir 
    $button_pacourrir = New-Object System.Windows.Forms.Button
    $button_pacourrir.Text = "Parcourir"
    $button_pacourrir.Location = [System.Drawing.Point]::new(50,180)
    $button_pacourrir.Cursor = 'Hand'
    $button_pacourrir.Size = [System.Drawing.Size]::new(90,35)


    #Bouton executer
    $button_executer = New-Object System.Windows.Forms.Button
    $button_executer.Text = "Execute"
    $button_executer.Location = [System.Drawing.Point]::new(140,180)
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
    $button_settings.Location = New-Object System.Drawing.Point(130,300)
    $button_settings.Size = [System.Drawing.Size]::new(90,35)

    #Voir les logs en directe
    $voir_log = New-Object System.Windows.Forms.Button
    $voir_log.Text= "Voir les logs"
    $voir_log.AutoSize = $true
    $voir_log.Cursor = 'Hand'
    $voir_log.Size = New-Object System.Drawing.Size(90 , 35)
    $voir_log.Location = New-Object System.Drawing.Point(30 ,300)

    $button_settings.Add_Click(
        {
            Show-Settings $fenetre
        }
    )


    
    $button_pacourrir.Add_Click(
        {
            Select-ScriptFile #Sélectionne le script 
        }
    )
    $button_download.Add_Click(
        {

            Export-Ticket $sessionheader $textbox_num.Text $button_download $textbox_num  #Export en CSV le ticket a
        }
    )

    $button_executer.Add_Click(
        {
            Start-ExecutionCSV -ticket $textbox_num.Text $textbox_num #Execute le script choisi
        }
    )

    $voir_log.Add_Click(
        {
            
            Get-ConsoleLog #Affichage de la console 
        }
    )

    $button_quitter.Add_Click(
        {
            if ($Global:logForm -ne $null -and -not $Global:logForm.IsDisposed) {
                $Global:logForm.Close() 
            }
            $fenetre.Close() #
        }
    )
    

    $fenetre.Controls.AddRange(
        $textbox_num,
        $label_question,
        $button_download,
        $button_quitter,
        $label_status,
        $Attente_code,
        $voir_log,
        $button_settings,
        $button_pacourrir,
        $button_executer

    )

    $fenetre.ShowDialog() | Out-Null
    
    
}

