# ![Logo](https://img4.hostingpics.net/pics/296698twitch.png) TwitchBotStream
TwitchBotStream est un BOT twitch réalisé en `NodeJS` et `CoffeeScript`, je tient à preciser que CoffeeScript est
indispensable pour une meilleure lecture du code sur la branch [develop](https://github.com/volca780/TwitchBotStream/tree/develop).

- Tâche réalisé par moi:
  - [x] Page d'administration
  - [x] Page d'installation
  - [ ] Administration - Statistique
  - [x] Administration - Commande
  - [x] Administration - Administation
  - [x] Administration - Evenement
  - [ ] Administration - Jeu
  - [ ] BOT - Commande
  - [ ] BOT - Evenement
  - [ ] BOT - Moderateur

- Tâche publique:
  - [x] Fichier de langue [FRA.ini](/data/lang/FRA.ini)
  - [ ] Fichier de langue GER.ini
  - [ ] Fichier de langue ENG.ini
  - [ ] Fichier de langue ITA.ini

## Installation

Pour installer vous aurez besoin de `NodeJS` et de `npm`

Une fois ces deux programme installé vous devrez executer cette commande pour installer toute les dependances
```
npm install
```
Lancé le serveur
```
npm start
```
Rendez-vous sur cette url pour acceder à la page d'administration du bot twitch
```
127.0.0.1:3000
```

## Information
L'utilisation de `CoffeeScript` est importante pour pouvoir réduire notre code de façon considérable. Voici quelque exemple:
```coffeescript
languageInit: -> #CHANGE LANGUAGE IN HTML CODE
  @LANGUAGE = JSON.parse @requestAjax get_url_lang, "GET"
  @CONFIG   = JSON.parse @requestAjax get_url_config, "GET"

  try document.getElementById("lang_install_next").innerHTML          = @LANGUAGE.LANGUAGE.lang_install_next
  try document.getElementById("lang_install_install").innerHTML       = @LANGUAGE.LANGUAGE.lang_install_install
  try document.getElementById("lang_install_installing").innerHTML    = @LANGUAGE.LANGUAGE.lang_install_installing
  try document.getElementById("lang_install_presentation").innerHTML  = @LANGUAGE.LANGUAGE.lang_install_presentation
```
