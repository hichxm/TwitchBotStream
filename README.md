# ![Logo](https://img4.hostingpics.net/pics/296698twitch.png) TwitchBotStream
TwitchBotStream est un BOT twitch réalisé en `NodeJS` et `CoffeeScript`, je tient à preciser que CoffeeScript est
indispensable pour une meilleure lecture du code sur la branch [develop](https://github.com/volca780/TwitchBotStream/tree/develop).

- Tâche réalisé par moi:
  - [x] Page d'administration
  - [x] Page d'installation
  - [x] Administration - Statistique
  - [x] Administration - Commande
  - [x] Administration - Administation
  - [x] Administration - Evenement
  - [ ] Administration - Jeu
  - [x] BOT - Variable
  - [x] BOT - Commande
  - [x] BOT - Evenement
  - [ ] BOT - Moderateur

- Tâche publique:
  - [x] Fichier de langue [FRA.ini](/data/lang/FRA.ini)
  - [ ] Fichier de langue GER.ini
  - [ ] Fichier de langue ENG.ini
  - [ ] Fichier de langue ITA.ini

## Installation

Pour installer vous aurez besoin de `NodeJS` et de `npm`

Un tutoriel vidéo disponible ici: [TUTO TwitchBotStream, le premier bot twitch 100% français.](https://youtu.be/2l4L9xcpIUQ)

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

## Variable globale

Variable      | Result
------------- | --------------------------
${username}   | Nom d'utilisateur
${title}      | Titre du stream
${game}       | Nom du jeu en cour
${resolution} | Resolution de l'écran
${fps}        | Nombre d'image par seconde
${lang}       | Langue du jeu
${id}         | Identfiant du stream
${viewer}     | Nombre de viewer actuelle
${follower}   | Nombre de follower actuelle
${views}      | Nombre de vue actuelle
${lang_s}     | Langage du streamer
${streamer}   | Nom du d'utilisateur du streamer
${url}        | Lien direct vers le stream

L'utilisation des variables sont définie par le billet de la fonction ```VarToText()``` disponible dans le fichier [server.coffee](https://github.com/volca780/TwitchBotStream/blob/develop/server.coffee)

```coffeescript
VarToText = (text, data) ->
  CONFIG = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
  INFO = JSON.parse requestAjax """https://api.twitch.tv/kraken/streams/#{CONFIG.USER.chanel}""", "GET"
  DATA = data.data
  text = text.toString()
  # ========================== #
  # Replace stream info        #
  # ========================== #
  .replace("${title}", INFO.stream.channel.status)
  .replace("${game}", INFO.stream.game)
  .replace("${resolution}", INFO.stream.video_height)
  .replace("${fps}", Math.round INFO.stream.average_fps)
  .replace("${lang}", INFO.stream.channel.language)
  .replace("${id}", INFO.stream._id)
  # ========================== #
  # Replace streamer info      #
  # ========================== #
  .replace("${viewer}", INFO.stream.viewers)
  .replace("${follower}", INFO.stream.channel.followers)
  .replace("${views}", INFO.stream.channel.views)
  .replace("${lang_s}", INFO.stream.channel.broadcaster_language)
  .replace("${streamer}", INFO.stream.channel.display_name)
  .replace("${url}", INFO.stream.channel.url)
  # ========================== #
  # Replace user info          #
  # ========================== #
  .replace("${username}", DATA.username)
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
