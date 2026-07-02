param(
    [Parameter(Mandatory = $true)]
    [string]$CheminCsv
)

if (-not (Test-Path $CheminCsv)) {
    Write-Error "Le fichier '$CheminCsv' n'existe pas."
    exit 1
}

$data = Import-Csv -Path $CheminCsv -Delimiter ";"

$dataModifiee = $data | ForEach-Object {
    $champsRequis = @($_.NOM, $_.Prénom, $_.Matricule, $_.Fonction)
    $estComplet = $true

    foreach ($champ in $champsRequis) {
        if ([string]::IsNullOrWhiteSpace($champ)) {
            $estComplet = $false
        }
    }

    if ($estComplet) {
        $statut = "Complet"
    } else {
        $statut = "Champs manquants"
    }

    $_ | Add-Member -MemberType NoteProperty -Name "Statut_Verification" -Value $statut -PassThru
}

$dossier = Split-Path -Path $CheminCsv -Parent
$nomFichier = [System.IO.Path]::GetFileNameWithoutExtension($CheminCsv)
$cheminSortie = Join-Path $dossier "$nomFichier`_verifie.csv"

$dataModifiee | Export-Csv -Path $cheminSortie -NoTypeInformation -Encoding utf8BOM -Delimiter ";"

Write-Host "Fichier vérifié exporté vers : $cheminSortie"