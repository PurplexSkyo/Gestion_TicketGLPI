. .\models\AppState.ps1

function Write-Log {
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

    Write-Host $logLine`n
}


