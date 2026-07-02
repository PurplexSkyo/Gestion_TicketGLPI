
. .\Services\LogService.ps1

#function qui nous permet de voir les erreurs du script ( en détails) 
function Get-ScriptErrors {

    #Les paramètres de la fonctions qui nous permet d'importer les variables utilsé dans la fonction
    param(
        $textbox,
        [string]$Texte   
    )

    $error_message = $_.Exception.Message 

    Write-Log "Erreur de récupération"
    Write-Log "$error_message"#Retourne l'erreur trouvé dans le script 
    
    $textbox = ""
    

}

#Fonction qui nous permet de savoir si les champs du ticket est vide ou pas
function Test-EmptyFields{

    param(
        $textbox,
        [string]$Texte
    )

   Write-Log  "Le champ content du ticket est vide ou absent"

    $textbox = ""
}

#Function qui permet d'enlever toute les balise html et autre du ticket 
function Clear-TicketContent{

    param(
        [string]$Texte
    )

    $Texte = $Texte -replace '(?i)<b>(.*?)</b>', '###QUESTION###$1'

    # Remplace les <br> par " | " pour garder les réponses multiples sur une ligne
    $Texte = $Texte -replace '(?i)<br\s*/?>', ' | '

    # Enlève les balises h1-h6 et les remplace par des retours à la ligne
    $Texte = $Texte -replace '(?is)<h[1-6][^>]*>(.*?)</h[1-6]>', "`r`n`$1`r`n"

    # Enlève les autres balises
    $Texte = $Texte -replace '(?i)</?(?:p|li|div|tr)[^>]*>', ''
    $Texte = $Texte -replace '<[^>]+>', ''

    #Enlève les tabulations et &nbsp et les remplace par des espaces
    $Texte = $Texte -replace '&nbsp;', ' '
    $Texte = $Texte -replace '[ \t]+', ' '

    # Affiche pas les numéros
    $Texte = $Texte -replace '\d+\)\s*', ''

    # Remet en lignes propres sur le marqueur
    $Texte = $Texte -replace '###QUESTION###', "`r`n"
    $Texte= $Texte -replace "(\r?\n){2,}", "`r`n"

    #Variable des résultats
    $text_resultat = $Texte.Trim()

    return $text_resultat #Retourne à la fin le texte nettoyer


}


#Function qui nous permet de savoir s'il y a des pairs de question / reponse dans le ticket
function Get-FieldPairs{

    param(
        [string]$textbox
    )

    {
        Write-Log "Aucune paire question/reponse trouvée dans ce ticket"

        $textbox.Text = "" #Va rendre le ticket vide 
    

    }


}                                                                                           # Nom   #
                                                                                            # TEST2 #
#Function qui récupère les question / réponses et permet de les placer dans leurs colonne   #       #
function Get-Tables {

    param(
        [array]$les_paires
    )

    # Récupère toutes les questions du tableau 
    $questionS = $les_paires | ForEach-Object {
        $_.Question 
    }
    # Récupère toutes les réponses tu tableau
    $reponseS = $les_paires | ForEach-Object {
        $_.Reponse 
    }
    $ligne_questions = [PSCustomObject]($questionS | ForEach-Object -Begin { $h = [ordered]@{} } -Process { $h[$_] = $_ } -End { $h })
    $ligne_reponses  = [PSCustomObject]($reponseS  | ForEach-Object -Begin { $h = [ordered]@{}; $i = 0 } -Process { $h[$questionS[$i]] = $_; $i++ } -End { $h })


    return $ligne_reponses #Retourne les paires trier

}

