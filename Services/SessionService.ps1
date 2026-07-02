. .\Services\LogService.ps1

$global:UrlApi = "https://your-API/apirest.php"

#Function qui initialise une session GLPI et récupère le jeton de session
function Start-Session{
    
    

    $the_headers = @{
        "App-Token"    = $global:App_token
        "Authorization" = "user_token $global:Jeton_api"
        "Content-Type" = "application/json"
    }
    
    $answer = Invoke-RestMethod -Uri "$global:UrlApi/initSession" -Method Get -Headers $the_headers 
    $SessionToken = $answer.session_token

    return $SessionToken
}

#Function qui prépare les en-têtes nécessaires aux requêtes authentifiées
function  Get-SessionHeaders{

    param (
        [string]$Session_Token
    )

    $the_session_token = @{
        "App-Token"     = $global:App_token
        "Session-Token" = $Session_Token
        "Content-Type"  = "application/json"
    }

    return $the_session_token
}

#Function qui ferme la fenêtre puis termine la session GLPI
function Close-Session {
    param (
        [hashtable]$Session_Token,
        [System.Windows.Forms.Form]$form
    )
    
    $form.Close()
    $finDeSession = Invoke-RestMethod -Uri "$global:UrlApi/killSession" -Method Get -Headers $Session_Token
    Write-Log "Fin de la session : $finDeSession"
    
}






