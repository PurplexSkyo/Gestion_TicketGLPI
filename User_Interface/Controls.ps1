. .\Services\FolderService.ps1
function Select-ScriptFile {


    $Document = [System.Environment]::GetFolderPath("MyDocuments")
    $Chemin = Join-Path $Document "Scripts_ps1" 

    
    New-Folder $Chemin

    Write-Log "Sélection du fichier"
    
    #Ouvre une boîte de dialogue pour sélectionner un script PowerShell
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Selectionner les scripts PS1"
    $dialog.InitialDirectory = "$Chemin"
    $dialog.Filter = "Scripts PowerShell (*.ps1)|*.ps1"
    if ($dialog.ShowDialog() -eq "OK") {

        $script:scriptSelectionne = $dialog.FileName
        $fichier_script = Split-Path $script:scriptSelectionne -Leaf

        $status_selection_fichier.Text = "Fichier choisis : $fichier_script"
        Write-Log "Fichier sélectionné: $fichier_script"
        

        Show-Information "Fichier choisis : $fichier_script"
    
    }

}







