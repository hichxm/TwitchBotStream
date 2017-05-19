#MAIN FILE

# CLIENT ID: https://api.twitch.tv/kraken/users/volca780?client_id=y5ga4viagr5qrsdjkr4pxp6scvbx3a

express = require "express"
expressApp = express()
ini = require "ini"
fs = require "fs"
sha1 = require "sha1"
XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest
tmi = require "tmi.js"
# ========================== #
# CheckBotStart() return     #
# true -> Bot Started        #
# false -> Bot Stoped        #
#                            #
# CheckWebInstalled() return #
# true -> Bot installed      #
# false -> Bot no installed  #
#                            #
# LOG()                      #
# arg1 [text] -> [BOT] text  #
# arg2 [save] -> true / false#
#                            #
# requestAjax()              #
# arg1 [url] -> url          #
# arg2 [method] -> method    #
#                            #
# VarToText()                #
# arg1 [text] -> text        #
# arg2 [data] -> data        #
# ========================== #
CheckBotStart = ->
  CONFIG = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
  if CONFIG.BOT.start
    return true
  else
    return false
CheckWebInstalled = ->
  CONFIG = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
  if CONFIG.OPTION.instalX is CONFIG.OPTION.instalXmax
    return true
  else
    return false
LOG = (save, LOG) ->
  if save
    fs.appendFileSync "./data/log/LOG.txt", """[BOT] #{LOG}\n"""
    console.log """[BOT] #{LOG}"""
  else
    console.log """[BOT] #{LOG}"""
requestAjax = (fun_url, fun_method) ->
  xmlHTTP = new XMLHttpRequest()
  xmlHTTP.open fun_method || "GET", fun_url, false
  xmlHTTP.setRequestHeader("Client-ID", "y5ga4viagr5qrsdjkr4pxp6scvbx3a");
  xmlHTTP.send null

  return xmlHTTP.responseText;
VarToText = (text, data) ->
  CONFIG = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
  STREAM_ONLINE = JSON.parse requestAjax """https://api.twitch.tv/kraken/streams/#{CONFIG.USER.chanel}""", "GET"
  DATA = data.data

  if STREAM_ONLINE.stream
    text = text.toString()

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

  else
    STREAM_OFFLINE = JSON.parse requestAjax """https://api.twitch.tv/kraken/channels/#{CONFIG.USER.chanel}""", "GET"
    text = text.toString()
      # ========================== #
      # Replace stream info        #
      # ========================== #
      .replace "${stream title}", STREAM_OFFLINE.status
      .replace "${stream game}", STREAM_OFFLINE.game
      .replace "${stream resolution}", ""
      .replace "${stream fps}", ""
      .replace "${stream lang}", STREAM_OFFLINE.language
      .replace "${stream id}", ""

      # ========================== #
      # Replace streamer info      #
      # ========================== #
      .replace "${brodcaster}", STREAM_OFFLINE.display_name
      .replace "${brodcaster viewer}", "0"
      .replace "${brodcaster follower}", STREAM_OFFLINE.followers
      .replace "${brodcaster views}", STREAM_OFFLINE.views
      .replace "${brodcaster lang}", STREAM_OFFLINE.broadcaster_language
      .replace "${brodcaster url}", STREAM_OFFLINE.url

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


  return text

# ========================== #
# Delete LOG file before     #
# starting                   #
# ========================== #
fs.unlink "./data/log/LOG.txt"

# ========================== #
# Define port (3000)         #
# Define public dir (public) #
# ========================== #
expressApp.listen 3000 #LISTENING PORT 3000
expressApp.use express.static('public') #ROUTING OF PUBLIC
LOG true, """Web: 127.0.0.1:3000"""

# ========================== #
# Define url of main file    #
#  - "/GET/data/config/"     #
#  - "/GET/data/lang/"       #
#  - "/GET/data/event/"      #
#  - "/GET/data/command/"    #
#  - "/GET/data/follower/"   #
#  - "/GET/data/viewer/"     #
#  - "/GET/data/message/"    #
#  - "/GET/data/log/"        #
# This file not accessible   #
# from public dir and        #
# convert INI file to JSON   #
# ========================== #
expressApp.get "/GET/data/config/", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
expressApp.get "/GET/data/lang/", (req, res) ->
  iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
  res.send ini.parse fs.readFileSync """./data/lang/#{iniFile.OPTION.lang}.ini""", 'utf-8'
expressApp.get "/GET/data/event/", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/command/event.ini", 'utf-8'
expressApp.get "/GET/data/command/", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/command/command.ini", 'utf-8'
expressApp.get "/GET/data/follower/", (req, res) ->
  iniFile = ini.parse fs.readFileSync "./data/stats/follower.ini", 'utf-8'
  iniFile.INFO.follower = VarToText "${brodcaster follower}",  {data: {username: ""}}
  fs.writeFileSync "./data/stats/follower.ini", ini.stringify(iniFile)

  res.send ini.parse fs.readFileSync "./data/stats/follower.ini", 'utf-8'
expressApp.get "/GET/data/viewer/", (req, res) ->
  iniFile = ini.parse fs.readFileSync "./data/stats/follower.ini", 'utf-8'
  iniFile.INFO.viewer = VarToText "${brodcaster viewer}",  {data: {username: ""}}
  fs.writeFileSync "./data/stats/viewer.ini", ini.stringify(iniFile)

  res.send ini.parse fs.readFileSync "./data/stats/viewer.ini", 'utf-8'
expressApp.get "/GET/data/message/", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/stats/message.ini", 'utf-8'
expressApp.get "/GET/data/log/", (req, res) ->
  res.send fs.readFileSync "./data/log/LOG.txt", 'utf-8'

# ========================== #
# Define url of main file    #
#  - "/PUT/data/config/"     #
# This file not accessible   #
# from public dir for edit   #
# ========================== #
expressApp.get "/PUT/data/config/", (req, res) ->
  # ========================== #
  # Edit config >option >instalX#
  # ========================== #
  if req.query["config.option.instalx"] #EDIT config.option.instalx
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.OPTION.instalX = req.query["config.option.instalx"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)
  # ========================== #
  # Edit config >user >chanel  #
  # ========================== #
  if req.query["config.user.chanel"] #EDIT config.user.chanel
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.USER.chanel = req.query["config.user.chanel"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)
  # ========================== #
  # Edit config >user >username#
  # ========================== #
  if req.query["config.user.username"] #EDIT config.user.username
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.USER.username = req.query["config.user.username"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)
  # ========================== #
  # Edit config >user >password#
  # ========================== #
  if req.query["config.user.password"] #EDIT config.user.password
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.USER.password = req.query["config.user.password"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)
  # ========================== #
  # Edit config >bot >color    #
  # ========================== #
  if req.query["config.bot.color"] #EDIT config.bot.color
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.BOT.color = req.query["config.bot.color"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)

  res.send "ok" #DATA/CONFIG.INI editing

# ========================== #
# Define url of main file    #
#  - "/SET/data/config/"     #
#  - "/SET/data/event/"      #
#  - "/SET/data/command/"    #
# This file not accessible   #
# from public dir            #
# ========================== #
expressApp.get "/SET/data/config/", (req, res) ->
  if req.query["config.bot.start"] #EDIT config.bot.start to "TRUE" or "FALSE"
    iniFile = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
    iniFile.BOT.start = req.query["config.bot.start"]
    fs.writeFileSync "./data/config.ini", ini.stringify(iniFile)

  res.send "ok"
expressApp.get "/SET/data/event/", (req, res) ->
  if req.query["command.event.event"]#EDIT command.event.event to "onJoin" / "onLeave"
    iniFile = ini.parse fs.readFileSync "./data/command/event.ini", 'utf-8'
    newEvent = {
      "#{sha1 Math.random(0, 10000000000).toString().substring(2)}": {
        event: req.query["command.event.event"],
        method: req.query["command.event.method"],
        message: req.query["command.event.message"]
      }
    }
    fs.appendFileSync "./data/command/event.ini", ini.stringify(newEvent)
  res.send "ok"
expressApp.get "/SET/data/command", (req, res) ->
  if req.query["command.command.command"]
    iniFile = ini.parse fs.readFileSync "./data/command/command.ini", "utf-8"
    newCommand = {
      "#{sha1 Math.random(0, 10000000000).toString().substring(2)}": {
        command: req.query["command.command.command"],
        method: req.query["command.command.method"],
        message: req.query["command.command.message"],
        user_stramer: req.query["command.command.perm.streamer"],
        user_moderat: req.query["command.command.perm.moderato"],
        user_user: req.query["command.command.perm.user"]
      }
    }
    fs.appendFileSync "./data/command/command.ini", ini.stringify(newCommand)
  res.send "ok"

# ========================== #
# TwitchBotCode              #
# ========================== #
if CheckWebInstalled()

  # ========================== #
  # Get data in config.ini     #
  # ========================== #
  CONFIG = ini.parse fs.readFileSync "./data/config.ini", 'utf-8'

  # ========================== #
  # Set main option of bot     #
  # ========================== #
  Client = new tmi.client {
    options: {
      debug: false
    },
    connection: {
      reconnect: true
    },
    identity: {
      username: CONFIG.USER.username,
      password: CONFIG.USER.password
    }
  }
  Client.api {
    url: "https://api.twitch.tv/kraken/",
    headers: {
      "Client-ID": "y5ga4viagr5qrsdjkr4pxp6scvbx3a",
      "Accept": "application/vnd.twitchtv.v3+json"
    }
  }, (err, res, body)->
    LOG true, "Client-ID: y5ga4viagr5qrsdjkr4pxp6scvbx3a"

  # ========================== #
  # When connected             #
  # ==========================
  Client.connect().then (data) ->
    LOG true, "==========================="
    LOG true, "CONNECTED"

  # ========================== #
  # When error                 #
  # ========================== #
  .catch (err) ->
    LOG true, "==========================="
    LOG true, "ERROR: Can't connect to IRC"
    LOG true, "==========================="
    LOG true, "CHECK YOUR PASSWORD OR MAKE"
    LOG true, "AN ISSUE ON GITHUB REPO    "
    LOG true, "==========================="

  # ========================== #
  # Detect when bot is         #
  # authentified               #
  # ========================== #
  Client.on "connected", (adress, port) ->
    LOG true, """Adress: #{adress}"""
    LOG true, """Port: #{port}"""

    Client.color """Green"""

    # ========================== #
    # Join chanel with a bot     #
    # ========================== #
    Client.join(CONFIG.USER.chanel).then (data) ->
      LOG true, """JOIN CHANEL ##{CONFIG.USER.chanel}"""

      # ========================== #
      # Detect when new message    #
      # on a chanel                #
      # ========================== #
      Client.on "chat", (channel, user, message, self) ->
        LOG false, """[#{channel}] <#{user['display-name']}>: #{message}"""

        if CheckBotStart()
          if !self
            COMMAND = ini.parse fs.readFileSync "./data/command/command.ini", 'utf-8'; n = 0
            while n < Object.keys(COMMAND).length
              if message is """!#{COMMAND[Object.keys(COMMAND)[n]]['command']}"""

                # ========================== #
                # Detect if user is streamer #
                # ========================== #
                if COMMAND[Object.keys(COMMAND)[n]]['user_stramer']
                  if CONFIG.USER.chanel is user['username']
                    if user['username'] is CONFIG.USER.chanel
                      LOG true, """[#{channel}] [#{user['display-name']}] [!#{COMMAND[Object.keys(COMMAND)[n]]['command']}]"""

                      # ========================== #
                      # Detect the method is "Chat"#
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Chat"
                        Client.say CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is "Me"  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Me"
                        Client.action CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is       #
                      # "Whisper"                  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Whisper"
                        Client.whisper user['username'], VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                # ========================== #
                # Detest if user is modo     #
                # ========================== #
                if COMMAND[Object.keys(COMMAND)[n]]['user_moderat']
                  if Client.isMod CONFIG.USER.chanel, user['username']
                    if user['username'] isnt CONFIG.USER.chanel
                      LOG true, """[#{channel}] [#{user['display-name']}] [!#{COMMAND[Object.keys(COMMAND)[n]]['command']}]"""

                      # ========================== #
                      # Detect the method is "Chat"#
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Chat"
                        Client.say CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is "Me"  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Me"
                        Client.action CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is       #
                      # "Whisper"                  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Whisper"
                        Client.whisper user['username'], VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                # ========================== #
                # Detect if user is simple   #
                # ========================== #
                if COMMAND[Object.keys(COMMAND)[n]]['user_user']
                  if !Client.isMod user['username'], CONFIG.USER.chanel
                    if user['username'] isnt CONFIG.USER.chanel
                      LOG true, """[#{channel}] [#{user['display-name']}] [!#{COMMAND[Object.keys(COMMAND)[n]]['command']}]"""

                      # ========================== #
                      # Detect the method is "Chat"#
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Chat"
                        Client.say CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is "Me"  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Me"
                        Client.action CONFIG.USER.chanel, VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }

                      # ========================== #
                      # Detect the method is       #
                      # "Whisper"                  #
                      # ========================== #
                      if COMMAND[Object.keys(COMMAND)[n]]['method'] is "Whisper"
                        Client.whisper user['username'], VarToText COMMAND[Object.keys(COMMAND)[n]]['message'], {
                          data: {
                            username: user['display-name']
                          }
                        }
              n++

      # ========================== #
      # Detect when new user       #
      # join a channel             #
      # ========================== #
      Client.on "join", (channel, username, self) ->
        if CheckBotStart()
          if !self
            EVENT = ini.parse fs.readFileSync "./data/command/event.ini", 'utf-8'; n = 0
            while n < Object.keys(EVENT).length
              if EVENT[Object.keys(EVENT)[n]]['event'] is "onJoin"
                LOG true, """[#{channel}] [#{username}] [#{EVENT[Object.keys(EVENT)[n]]['event']}]"""

                # ========================== #
                # Detect the method is "Chat"#
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Chat"
                  Client.say CONFIG.USER.chanel, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

                # ========================== #
                # Detect the method is "Me"  #
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Me"
                  Client.action CONFIG.USER.chanel, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

                # ========================== #
                # Detect the method is       #
                # "Whisper"                  #
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Whisper"
                  Client.whisper username, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

              n++

      # ========================== #
      # Detect when user           #
      # quit a channel             #
      # ========================== #
      Client.on "part", (channel, username, self) ->
        if CheckBotStart()
          if !self
            EVENT = ini.parse fs.readFileSync "./data/command/event.ini", 'utf-8'; n = 0
            while n < Object.keys(EVENT).length
              if EVENT[Object.keys(EVENT)[n]]['event'] is "onLeave"
                LOG true, """[#{channel}] [#{username}] [#{EVENT[Object.keys(EVENT)[n]]['event']}]"""

                # ========================== #
                # Detect the method is "Chat"#
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Chat"
                  Client.say CONFIG.USER.chanel, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

                # ========================== #
                # Detect the method is "Me"  #
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Me"
                  Client.action CONFIG.USER.chanel, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

                # ========================== #
                # Detect the method is       #
                # "Whisper"                  #
                # ========================== #
                if EVENT[Object.keys(EVENT)[n]]['method'] is "Whisper"
                  Client.whisper username, VarToText EVENT[Object.keys(EVENT)[n]]['message'], {
                    data: {
                      username: username
                    }
                  }

              n++

    # ========================== #
    # When error                 #
    # ========================== #
    .catch ->
      LOG true, "ERROR: Chanel can't connect..."
      process.exit()
