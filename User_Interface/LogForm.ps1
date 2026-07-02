function Get-ConsoleLog {

    Write-Log "Entrer dans la console"
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