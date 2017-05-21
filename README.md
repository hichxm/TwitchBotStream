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
  - [x] Fichier de langue [ENG.ini](/data/lang/ENG.ini)
  - [x] Fichier de langue [ITA.ini](/data/lang/ITA.ini) [#2](https://github.com/volca780/TwitchBotStream/issues/2)
  - [x] Fichier de langue [TUR.ini](/data/lang/TUR.ini)
  - [ ] Fichier de langue GER.ini

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

Variable      | Resultat
------------- | --------------------------
${brodcaster}           | Nom du streamer
${brodcaster viewer}    | Nombre de viewer
${brodcaster follower}  | Nombre de follower
${brodcaster views}     | Nombre de vue
${brodcaster lang}      | Langue du streamer
${brodcaster url}       | Url vers le stream
**----------------------------------------------** | **----------------------------------------------**
${streamer title}       | Titre du stream
${streamer game}        | Jeu du stream
${streamer resolution}  | Resolution du stream
${streamer fps}         | Fps du stream
${streamer lang}        | Langue du jeu
${streamer url}         | Url du stream
**----------------------------------------------** | **----------------------------------------------**
${username}             | Nom d'utilisateur
${username follower}    | Nombre de follower de l'utilisateur
${username views}       | Nombre de vue de l'utilisateur
${username url}         | Url vers l'utilisateur
${username lang}        | Langue de l'utilisateur



L'utilisation des variables sont définie par le billet de la fonction ```VarToText()``` disponible dans le fichier [server.coffee](https://github.com/volca780/TwitchBotStream/blob/develop/server.coffee#L41)

```coffeescript
# ========================== #
# Replace stream info        #
# ========================== #
.replace "${stream title}", STREAM_ONLINE.channel.status
.replace "${stream game}", STREAM_ONLINE.game
.replace "${stream resolution}", STREAM_ONLINE.stream.video_height
.replace "${stream fps}", MATH.round STREAM_ONLINE.stream.average_fps
.replace "${stream lang}", STREAM_ONLINE.stream.channel.language
.replace "${stream id}", STREAM_ONLINE.stream._id

# ========================== #
# Replace streamer info      #
# ========================== #
.replace "${brodcaster}", STREAM_ONLINE.stream.channel.display_name
.replace "${brodcaster viewer}", STREAM_ONLINE.stream.viewers
.replace "${brodcaster follower}", STREAM_ONLINE.stream.channel.followers
.replace "${brodcaster views}", STREAM_ONLINE.stream.channel.views
.replace "${brodcaster lang}", STREAM_ONLINE.stream.channel.broadcaster_language
.replace "${brodcaster url}", STREAM_ONLINE.stream.channel.url

# ========================== #
# Replace user info          #
# ========================== #
.replace "${username}", ->
  if DATA.username
    return DATA.username
  else if not DATA.username
    return "undefined"
.replace "${username follower}", ->
  if DATA.username
    USER = JSON.parse requestAjax """https://api.twitch.tv/kraken/channels/#{DATA.username}""", "GET"
    return USER.followers
  else if not DATA.username
    return ""
.replace "${username views}", ->
  if DATA.username
    USER = JSON.parse requestAjax """https://api.twitch.tv/kraken/channels/#{DATA.username}""", "GET"
    return USER.views
  else if not DATA.username
    return ""
.replace "${username url}", ->
  if DATA.username
    USER = JSON.parse requestAjax """https://api.twitch.tv/kraken/channels/#{DATA.username}""", "GET"
    return USER.url
  else if not DATA.username
    return ""
.replace "${username lang}", ->
  if DATA.username
    USER = JSON.parse requestAjax """https://api.twitch.tv/kraken/channels/#{DATA.username}""", "GET"
    return USER.language
  else if not DATA.username
    return ""
```

## Langage
Pour changer le langage du bot, il vous suffit d'acceder au fichier [config.ini](/data/config.ini) pour modifier le contenu de la variable ```lang``` les langues disponible:
  - **FRA**
  - **ITA**

```ini
[OPTION]
lang=FRA
```
Le code du langage est juste ici:
```coffeescript
languageInit: ->
  @LANGUAGE = JSON.parse @requestAjax get_url_lang, "GET"
  @CONFIG = JSON.parse @requestAjax get_url_config, "GET"

  try document.getElementById("lang_install_next").innerHTML                        = @LANGUAGE.LANGUAGE.lang_install_next
  try document.getElementById("lang_install_install").innerHTML                     = @LANGUAGE.LANGUAGE.lang_install_install
  try document.getElementById("lang_install_installing").innerHTML                  = @LANGUAGE.LANGUAGE.lang_install_installing
  try document.getElementById("lang_install_presentation").innerHTML                = @LANGUAGE.LANGUAGE.lang_install_presentation
  try document.getElementById("lang_install_bot_game").innerHTML                    = @LANGUAGE.LANGUAGE.lang_install_bot_game
  try document.getElementById("lang_install_bot_spam").innerHTML                    = @LANGUAGE.LANGUAGE.lang_install_bot_spam
  try document.getElementById("lang_install_bot_mods").innerHTML                    = @LANGUAGE.LANGUAGE.lang_install_bot_mods
  try document.getElementById("lang_install_bot_blacklist").innerHTML               = @LANGUAGE.LANGUAGE.lang_install_bot_blacklist
  try document.getElementById("lang_install_select_chanel").innerHTML               = @LANGUAGE.LANGUAGE.lang_install_select_chanel
  try document.getElementById("lang_install_select_user").innerHTML                 = @LANGUAGE.LANGUAGE.lang_install_select_user
  try document.getElementById("lang_install_user").innerHTML                        = @LANGUAGE.LANGUAGE.lang_install_user
  try document.getElementById("lang_install_password").innerHTML                    = @LANGUAGE.LANGUAGE.lang_install_password
  try document.getElementById("lang_install_bot_edit").innerHTML                    = @LANGUAGE.LANGUAGE.lang_install_bot_edit
  try document.getElementById("lang_install_bot_color").innerHTML                   = @LANGUAGE.LANGUAGE.lang_install_bot_color
  try document.getElementById("lang_install_success").innerHTML                     = @LANGUAGE.LANGUAGE.lang_install_success
  try document.getElementById("lang_install_administration").innerHTML              = @LANGUAGE.LANGUAGE.lang_install_administration
  try document.getElementById("lang_admin_administration").innerHTML                = @LANGUAGE.LANGUAGE.lang_admin_administration
  try document.getElementById("lang_nav_statistic").innerHTML                       = @LANGUAGE.LANGUAGE.lang_nav_statistic
  try document.getElementById("lang_nav_command").innerHTML                         = @LANGUAGE.LANGUAGE.lang_nav_command
  try document.getElementById("lang_nav_title").innerHTML                           = @LANGUAGE.LANGUAGE.lang_nav_title
  try document.getElementById("lang_nav_admin").innerHTML                           = @LANGUAGE.LANGUAGE.lang_nav_admin
  try document.getElementById("lang_panel_admin").innerHTML                         = @LANGUAGE.LANGUAGE.lang_panel_admin
  try document.getElementById("lang_panel_bot_start").innerHTML                     = @LANGUAGE.LANGUAGE.lang_panel_bot_start
  try document.getElementById("lang_panel_bot_stop").innerHTML                      = @LANGUAGE.LANGUAGE.lang_panel_bot_stop
  try document.getElementById("lang_panel_bot_color").innerHTML                     = @LANGUAGE.LANGUAGE.lang_panel_bot_color
  try document.getElementById("lang_panel_bot_color_hex").innerHTML                 = @LANGUAGE.LANGUAGE.lang_panel_bot_color_hex
  try document.getElementById("lang_panel_bot_color_save").innerHTML                = @LANGUAGE.LANGUAGE.lang_panel_bot_color_save
  try document.getElementById("lang_panel_command_event").innerHTML                 = @LANGUAGE.LANGUAGE.lang_panel_command_event
  try document.getElementById("lang_panel_command_method_me").innerHTML             = @LANGUAGE.LANGUAGE.lang_panel_command_method_me
  try document.getElementById("lang_panel_command_method_chat").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_command_method_chat
  try document.getElementById("lang_panel_command_method_whisper").innerHTML        = @LANGUAGE.LANGUAGE.lang_panel_command_method_whisper
  try document.getElementById("lang_panel_command_action_join").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_command_action_join
  try document.getElementById("lang_panel_command_action_leave").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_action_leave
  try document.getElementById("lang_panel_command_command").innerHTML               = @LANGUAGE.LANGUAGE.lang_panel_command_command
  try document.getElementById("lang_panel_command_add").innerHTML                   = @LANGUAGE.LANGUAGE.lang_panel_command_add
  try document.getElementById("lang_panel_command_command_add").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_command_command_add
  try document.getElementById("lang_panel_command_event_me").innerHTML              = @LANGUAGE.LANGUAGE.lang_panel_command_event_me
  try document.getElementById("lang_panel_command_event_chat").innerHTML            = @LANGUAGE.LANGUAGE.lang_panel_command_event_chat
  try document.getElementById("lang_panel_command_event_whisper").innerHTML         = @LANGUAGE.LANGUAGE.lang_panel_command_event_whisper
  try document.getElementById("lang_panel_command_command_command").innerHTML       = @LANGUAGE.LANGUAGE.lang_panel_command_command_command
  try document.getElementById("lang_panel_command_command_result").innerHTML        = @LANGUAGE.LANGUAGE.lang_panel_command_command_result
  try document.getElementById("lang_panel_command_command_option").innerHTML        = @LANGUAGE.LANGUAGE.lang_panel_command_command_option
  try document.getElementById("lang_panel_command_event_event").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_command_event_event
  try document.getElementById("lang_panel_command_event_method").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_event_method
  try document.getElementById("lang_panel_command_event_result").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_event_result
  try document.getElementById("lang_panel_command_event_option").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_event_option
  try document.getElementById("lang_panel_command_command_owner").innerHTML         = @LANGUAGE.LANGUAGE.lang_panel_command_command_owner
  try document.getElementById("lang_panel_command_command_user").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_command_user
  try document.getElementById("lang_panel_command_command_modo").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_command_command_modo
  try document.getElementById("lang_panel_stats").innerHTML                         = @LANGUAGE.LANGUAGE.lang_panel_stats
  try document.getElementById("lang_panel_stats_follower").innerHTML                = @LANGUAGE.LANGUAGE.lang_panel_stats_follower
  try document.getElementById("lang_panel_stats_viewer").innerHTML                  = @LANGUAGE.LANGUAGE.lang_panel_stats_viewer
  try document.getElementById("lang_panel_stats_message").innerHTML                 = @LANGUAGE.LANGUAGE.lang_panel_stats_message
  try document.getElementById("lang_panel_stats_sondage").innerHTML                 = @LANGUAGE.LANGUAGE.lang_panel_stats_sondage
  try document.getElementById("lang_panel_stats_form_question").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_stats_form_question
  try document.getElementById("lang_panel_stats_form_question_add").innerHTML       = @LANGUAGE.LANGUAGE.lang_panel_stats_form_question_add
  try document.getElementById("lang_panel_stats_form_reponse").innerHTML            = @LANGUAGE.LANGUAGE.lang_panel_stats_form_reponse
  try document.getElementById("lang_panel_stats_form_reponse_add").innerHTML        = @LANGUAGE.LANGUAGE.lang_panel_stats_form_reponse_add
  try document.getElementById("lang_panel_stats_table_question").innerHTML          = @LANGUAGE.LANGUAGE.lang_panel_stats_table_question
  try document.getElementById("lang_panel_stats_table_reponse").innerHTML           = @LANGUAGE.LANGUAGE.lang_panel_stats_table_reponse

  try document.getElementById("config_bot_name").innerHTML                          = @CONFIG.USER.username
```

## Bug commun
Cette section est dédiée au bug les plus commun sur l'application

>Probleme: ```npm WARN twitchbotstream@x.x.x No repository field.```

>Solution: [#1](https://github.com/volca780/TwitchBotStream/issues/1)

## Information
L'utilisation de `CoffeeScript` est importante pour pouvoir réduire notre code de façon considérable. Voici un exemple:
```coffeescript
@COMMAND = JSON.parse @requestAjax get_url_command, "GET"
n = 0
while n < Object.keys(@COMMAND).length
  console.log @COMMAND[Object.keys(@COMMAND)[n]]
  document.getElementById("panel_command_command_table").innerHTML += """
  <tr>
    <td>#{@COMMAND[Object.keys(@COMMAND)[n]]['command']}</td>
    <td>#{@COMMAND[Object.keys(@COMMAND)[n]]['method']}</td>
    <td>#{@COMMAND[Object.keys(@COMMAND)[n]]['message']}</td>
    <td>#{if @COMMAND[Object.keys(@COMMAND)[n]]['user_user'] then """<i class="fa fa-check" aria-hidden="true"></i>""" else """<i class="fa fa-times" aria-hidden="true"></i>"""}</td>
    <td>#{if @COMMAND[Object.keys(@COMMAND)[n]]['user_moderat'] then """<i class="fa fa-check" aria-hidden="true"></i>""" else """<i class="fa fa-times" aria-hidden="true"></i>"""}</td>
    <td>#{if @COMMAND[Object.keys(@COMMAND)[n]]['user_stramer'] then """<i class="fa fa-check" aria-hidden="true"></i>""" else """<i class="fa fa-times" aria-hidden="true"></i>"""}</td>
    <td><i class="fa fa-trash" aria-hidden="true"></i> <i class="fa fa-check-circle-o" aria-hidden="true"></i></td>
  </tr>
  """
  n++

```
