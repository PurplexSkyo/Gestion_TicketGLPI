# Gestion de Ticket GLPI
Gestion de ticket est une application Windows (interface winforms ) pour les techniciens qui traitent des ticket GLPI au quotidien. Elle permet de récupérer un ticket via l'API GLPI, de l'exporter en CSV. Elle permet également d'executer des scripts en prenant l'ID du ticket en argument. 
L'objectif de cette application est de simplifié le quotidien des techniciens et d'automatiser le traitement des ticket sans avoir besoin d'ouvrir GLPI 

## Fonctionnalité 
- Télécharger un Ticket et de l'exporter en CSV
- Visualiser les logs en temps réel 
- Sélectionnner des fichier .ps1
- Exécuter des fichiers .ps1 avec l'ID du ticket en argumen 
- Basculer d'un APP-Token à un autre App-token
- Interface de connexion
- Deux boutons d'aide sur l'interface de connexion pour expliquer comment obtenir les tokens

## Pré-requis 
- Powershell 7+
- Windows Powershell ISE ou Visual studio code
  

*Si vous vouliez lancer depuis Visual Studio Code, télécharger l'extension Powershell*

## Installation
### Obtenir powershell 7+
- Windows :
  ```bash
  winget install --id Microsoft.PowerShell --source winget
  ```
- Mac OS :
  
    ```bash
  brew update
  brew install --cask powershell
  ```
- Linux :
   ```bash
  
  sudo apt-get update
  sudo apt-get install -y wget apt-transport-https software-properties-common
  wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update
  sudo apt-get install -y powershell
   ```


## L'obtenir
```bash
git clone https://github.com/PurplexSkyo/Gestion_TicketGLPI
cd Gestion_Ticketing
```

## Utilisation 
Sélectionner dossier service --> sélectionner le fichier SessionServices.ps1 --> modifier l'UrlAPI à votre API REST
### L'utiliser
```bash
Application_Ticket.bat
```
ou directement :
```bash
Gestion_Ticket.ps1
```
## FAQ 

**Q : Où puis-je trouver mon App-Token GLPI ?**
*R : Clique sur le bouton d'aide (?) à côté du champ App-Token sur l'interface de connexion*

**Q : Que faire si mon App-Token est invalide ou expiré ?**
*R : Renseigne-toi auprès de ton administrateur.*

**Q : Je veux changer mon App-Token, comment faire ?**
*R: Cliqué dans sur le bouton "Settings" depuis la fenêtre principale, entrée votre nouveau app token puis appuis sur "Valider". Attendez que l'App-Token est récupéré un nouveau Session Token avant de continuer.*

**Q : Puis-je enregistrer plusieurs App-Tokens pour changer plus rapidement ?**
*R : Non*

**Q :Les logs sont-ils sauvegardé ou affiché que en temps réel.**
*R: les logs ne sont affiché que en temps réel*

**Pourquoi le bouton "Parcourir" ouvre-t-il le dossier Script_ps1 par défaut, et comment importer mes propres scripts ?**
*R : Le dossier Script_ps1 a été mis en place comme dossier par défaut pour retrouver facilement les scripts .ps1 utilisés au quotidien. Si tu veux importer tes scrips ,place-les dans "Documents" puis > dossier Script_ps1 : ils apparaîtront ensuite directement quand tu cliques sur "Parcourir".*


**Q : L'application ne se lance pas, que faire ?**
*R : Verifié que powershell 7+ est bien installé depuis l'invite de commande (`pswh --version`)*

**Q: Comment je fais pour utiliser mon script ps1 sur le ticket choisi?**
*R : Appuyez sur "Parcourir", sélectionne le script ps1, puis entre l'ID du ticket dans la case qui permet de télécharger le ticket.*

**Q : Où sont exportés les fichiers CSV ?**
*R: Les fichiers CSV sont exportés dans un dossier avec leurs ID dans "Documents"*

**Q: Puis-je traiter plusieurs ticket à la fois?**
*R : Non*




## Technologies
- Winform 
- Powershell 7+

# License

### PurplexSkyo -- Natan Poulain. -- Projet réalisé dans le cadre d'un stage informatique

