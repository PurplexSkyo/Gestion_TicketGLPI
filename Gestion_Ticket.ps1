. .\User_Interface\MainScreen.ps1
. .\User_Interface\Sign_in_UI\Sign_in.ps1
. .\Services\ApiService.ps1

#met la session false
$session_trouvee = $false

while (-not $session_trouvee)
{
    Show-SignInDialog

    try
    {

        $token = Start-Session  #Recherche le token de session 

        if ([string]::IsNullOrWhiteSpace($token))
        {   
            
            Show-Warning "Session token introuvable. Vérifiez vos tokens et réessayez."
            #Erreur affichant que le token n'a pas été trouvé
        }
        else
        {
            $session_trouvee = $true
        }
    }
    catch
    {
        Show-Warning "Connexion invalide.`n$($_.Exception.Message)"
    }
}
Show-Information "Connexion avec succès" #Affiche une page avec une icon information
$Headers = Get-SessionHeaders $token #Réupère le Session Token 
Show-MainWindow -sessionheader $Headers #Affiche la fenetre princpale