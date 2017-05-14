#MAIN FILE
express = require "express"
expressApp = express()
ini = require "ini"
fs = require "fs"
BodyParser = require "body-parser"
sha1 = require "sha1"



# ========================== #
# Define port (3000)         #
# Define public dir (public) #
# ========================== #
expressApp.listen 3000 #LISTENING PORT 3000
expressApp.use express.static('public') #ROUTING OF PUBLIC

# ========================== #
# Define url of main file    #
#  - "/GET/data/config/"     #
#  - "/GET/data/lang/"       #
#  - "/GET/data/event/"      #
#  - "/GET/data/command/"    #
# This file not accessible   #
# from public dir            #
# ========================== #
expressApp.get "/GET/data/config/", (req, res) -> #DATA/CONFIG.INI to JSON
  res.send ini.parse fs.readFileSync "./data/config.ini", 'utf-8'
expressApp.get "/GET/data/lang/", (req, res) -> #DATA/LANG/$LANG.INI to JSON
  Parsed = ini.parse fs.readFileSync "./data/config.ini", "utf-8"
  res.send ini.parse fs.readFileSync "./data/lang/#{Parsed.OPTION.lang}.ini", 'utf-8'
expressApp.get "/GET/data/event/", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/command/event.ini", 'utf-8'
expressApp.get "/GET/data/command", (req, res) ->
  res.send ini.parse fs.readFileSync "./data/command/command.ini", 'utf-8'

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
