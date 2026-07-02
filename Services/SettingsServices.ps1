

function New-Key
{
    param(
        [string]$app,
        $textbox
    )

    Write-Log "Confirmation pour changer l'App-Token"

    

    if([string]::IsNullOrWhiteSpace($app))
    {
        $a = Show-Error "App Token vide"
        return $false
    }
    elseif ($app.Length -ne 40)
    {
        $c =Show-Error "Le APP TOKEN ne doit contenir que 40 caractères"
        return $false
    }
    else {
        $global:App_token = $app
        return $true
    }

    $session_trouvee = $false
    try 
    {
        

        $token = Start-Session

        

        if ([string]::IsNullOrWhiteSpace($token))
        {   
            
            Show-Warning "Session token introuvable. Vérifiez vos tokens et réessayez."
            Write-Log "La session token n'a pas été trouvé"
        }
        else
        {   
            Write-Log "Session Token trouvé"
            $session_trouvee = $true
        }
    }
    catch 
    {
        Show-Warning "Connexion invalide.`n$($_.Exception.Message)"
    }

    $textbox.Text = ""
    $textbox.Focus()
    

}