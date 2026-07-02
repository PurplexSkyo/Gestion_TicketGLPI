Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


function Show-LoadingBar {
    
    $Chargement_bar = New-Object System.Windows.Forms.Form
    $Chargement_bar.Text = "Chargement de la session"
    $Chargement_bar.Size = New-Object System.Drawing.Size(400,120)
    $Chargement_bar.StartPosition = 'CenterScreen'
    $Chargement_bar.FormBorderStyle = 'FixedDialog'

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Récupération du Session Token..."
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(20, 15)
    $Chargement_bar.Controls.Add($label)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Style = 'Marquee'
    $progressBar.MarqueeAnimationSpeed = 30
    $progressBar.Location = New-Object System.Drawing.Point(20, 45)
    $progressBar.Size = New-Object System.Drawing.Size(240, 20)
    $Chargement_bar.Controls.Add($progressBar)
    



    return $Chargement_bar
}


