Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

. .\Services\SettingsServices.ps1



function Show-Settings{

    param(
        $mainform
    )

    if ($script:setting_tab -and -not $script:setting_tab.IsDisposed) 
    {
        $script:setting_tab.Activate()
        $script:setting_tab.BringToFront()
        return
    }

    #Settings | Intérieur des paramètres
    $script:setting_tab = New-Object System.Windows.Forms.Form
    $setting_tab = $script:setting_tab
    $setting_tab.Text = "Settings"
    $setting_tab.Size = New-Object System.Drawing.Size(300,200)
    $setting_tab.FormBorderStyle = 'FixedDialog'
    $setting_tab.StartPosition = 'Manual'
    $setting_tab.Location = [System.Drawing.Point]::new(250,110)



    $label_change_app_token = New-Object System.Windows.Forms.Label
    $label_change_app_token.AutoSize = $true
    $label_change_app_token.Location = [System.Drawing.Point]::new(20,10)
    $label_change_app_token.Text = "Changer l'App-Token "
    $setting_tab.Controls.Add($label_change_app_token)

    $script:textbox_change_app_token = New-Object System.Windows.Forms.TextBox
    $textbox_change_app_token.Width = 150
    $textbox_change_app_token.UseSystemPasswordChar = $true
    $textbox_change_app_token.Location = [System.Drawing.Point]::new(20,30)
    $setting_tab.Controls.Add($textbox_change_app_token)



    $button_valider = New-Object System.Windows.Forms.Button
    $button_valider.Text = "Valider"
    $button_valider.Size = [System.Drawing.Size]::new(70,30)
    $button_valider.Location = [System.Drawing.Point]::new(180, 25)  
    $setting_tab.Controls.Add($button_valider) 


    $button_quitter = New-Object System.Windows.Forms.Button
    $button_quitter.Text  =  "Quitter"
    $button_quitter.AutoSize = $true
    $button_quitter.Location = [System.Drawing.Point]::new(190, 120)  
    $setting_tab.Controls.Add($button_quitter)



    $button_quitter.Add_Click(
        {
            $setting_tab.Close()

        }.GetNewClosure()
    )
    $button_valider.Add_Click(
        {
            Write-Log "text : $($script:textbox_change_app_token)"
            New-Key  -app $script:textbox_change_app_token.Text $script:textbox_change_app_token
        }
    )

    $mainform.Add_FormClosing(
    {
        #Se ferme si la fênetre principale n'existe plus
        if ($script:setting_tab -and -not $script:setting_tab.IsDisposed) {
            $script:setting_tab.Close()
        }
    }
)


    $setting_tab.Show()
}

