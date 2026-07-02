Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
. .\Services\FolderService.ps1
. .\User_Interface\Sign_in_UI\Sign_in_controls.ps1



[System.Windows.Forms.Application]::EnableVisualStyles()

function Show-SignInDialog{


        
    #Fenêtre de connextion 
    $page_de_connection = New-Object System.Windows.Forms.Form
    $page_de_connection.Text = "Connexion"
    $page_de_connection.FormBorderStyle = 'FixedDialog'
    $page_de_connection.StartPosition = 'CenterScreen'
    $page_de_connection.Size = New-Object System.Drawing.Size(500,400)
    $page_de_connection.BackColor = [System.Drawing.Color]::WhiteSmoke
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
    $help_user_btn.BackColor = [System.Drawing.Color]::White
    $help_user_btn.Location = New-Object System.Drawing.Point(20,115)
    $page_de_connection.Controls.Add($help_user_btn)



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
    $help_app_btn.BackColor = [System.Drawing.Color]::White
    $help_app_btn.Size = New-Object System.Drawing.Size(10)
    $help_app_btn.Location = New-Object System.Drawing.Point(20,160)
    $page_de_connection.Controls.Add($help_app_btn)




    #Le Boutton valider
    $validation_both = New-Object System.Windows.Forms.Button
    $validation_both.Text = "Valider"
    $validation_both.Cursor = 'Hand'
    $validation_both.Font  = New-Object System.Drawing.Font('Geogia',11)
    $validation_both.Size = New-Object System.Drawing.Size(90,35)
    $validation_both.Location = New-Object System.Drawing.Point(190,210)
    $validation_both.BackColor = [System.Drawing.Color]::White
    $page_de_connection.Controls.Add($validation_both)



    #Le bouton quitter
    $button_leave_page_connexion = New-Object System.Windows.Forms.Button
    $button_leave_page_connexion.Text = "Quitter"
    $button_leave_page_connexion.Size = New-Object System.Drawing.Size(80,35)
    $button_leave_page_connexion.Location = New-Object System.Drawing.Point(390,310)
    $button_leave_page_connexion.DialogResult = 'Cancel'
    $button_leave_page_connexion.Cursor = 'Hand'
    $button_leave_page_connexion.BackColor = [System.Drawing.Color]::White
    $button_leave_page_connexion.Font  = New-Object System.Drawing.Font('Georgia',11)
    $page_de_connection.Controls.Add($button_leave_page_connexion)


    #Ouvre l'aide pour le jeton API utilisateur
    $help_user_btn.Add_Click(
        {
            Show-ApiTokenHelp
        }
    )

    #Ouvre l'aide pour l'App Token
    $help_app_btn.Add_Click(
        {
            Show-AppTokenHelp
        }
    )

    #Valide les jetons puis ferme la fenêtre si tout est correct
    $validation_both.Add_Click(
        {
            $les_tokens = Test-Tokens $user_textbox.Text $app_textbox.Text
            
            if ($les_tokens -eq $true)
            {
                $page_de_connection.DialogResult = [System.Windows.Forms.DialogResult]::OK
                $page_de_connection.Close()
            }
        }
    )

    #Quitte l'application si la fenêtre est fermée ou annulée
    $result = $page_de_connection.ShowDialog()

    
    if ($result -eq "Cancel")
    {

        exit 
    }
}
