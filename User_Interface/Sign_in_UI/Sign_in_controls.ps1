. .\Services\LogService.ps1
. .\Services\FolderService.ps1
. .\Services\ScriptService.ps1

#Function qui affiche les étapes pour récupérer le jeton API utilisateur
function Show-ApiTokenHelp {
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

#function qui indique comment obtenir l'App Token
function Show-AppTokenHelp {
    [System.Windows.Forms.MessageBox]::Show(
        "Veuillez contacter un administrateur afin d'obtenir l'App-Token nécessaire à l'utilisation de l'API REST GLPI.",
        "Aide sur app token",
        "OK",
        "Information"
    )
}

#function qui vérifie que les deux jetons sont renseignés et valides

function Test-Tokens {
    param(
        [string]$txt_jeton_api,
        [string]$text_app_token
    )

    $app = $text_app_token
    $token = $txt_jeton_api

    if ([string]::IsNullOrWhiteSpace($app) -or [string]::IsNullOrWhiteSpace($token)) 
    {
        $a = Show-Error "App Token ou Jeton d'API vide"
        return $false
       
    }
    elseif ($token.Length -ne 40) 
    {
        $b = Show-Error "Le Jeton d'API ne doit contenir que 40 caractères"
        return $false
    }
    elseif ($app.Length -ne 40)
    {
        $c =Show-Error "Le APP TOKEN ne doit contenir que 40 caractères"
        return $false
    }

     #Variable qui stocke les jetons pour les utiliser dans le reste de l'application
    $global:Jeton_api = $token
    $global:App_token = $app
    
    return $true
}