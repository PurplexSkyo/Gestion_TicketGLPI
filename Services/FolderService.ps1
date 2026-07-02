. .\Services\LogService.ps1

function New-Folder{

    param(
        [string]$Chemin
    )

    if (-not(Test-Path $Chemin))
    {
        Write-Log "Le dossier n'a pas été crée"
        Write-Log "Création du dossier $Chemin"
        New-Item -Path $Chemin -ItemType Directory -Force | Out-Null
        Write-Log "Le Dossier est crée"
        Write-Log "Chemin d'accès $Chemin"
    }
    
}

