class TwitchBotStream

  get_url_config = "/get/data/config/"
  get_url_lang = "/get/data/lang/"
  get_url_command = "/get/data/command"
  get_url_event = "/get/data/event/"
  get_url_follower = "/get/data/follower/"
  get_url_viewer = "/get/data/viewer/"
  get_url_message = "/get/data/message/"
  get_url_log = "/get/data/log/"
  put_url_config = "/put/data/config/"
  set_url_data = "/set/data/config/"
  set_url_event = "/set/data/event/"
  set_url_command = "/set/data/command/"

  init: ->
    LANGUAGE = null
    CONFIG = null
    EVENT = null
    COMMAND = null
    FOLLOWER = null
    VIEWER = null
    LOG = null

    if !@checkInstall()
      document.location = "/installation/"

  # ========================== #
  # Initialised                #
  # "/#administration"         #
  # ========================== #
  admin_panel_0: ->
    that = @
    if that.checkBotStart() #VERIFY ACTUAL STATUS OF BOT
      document.getElementById("lang_panel_bot_start").classList.add "active"
      document.getElementById("lang_panel_bot_stop").classList.remove "active"
    else if !that.checkBotStart() #VERIFY ACTUAL STATUS OF BOT
      document.getElementById("lang_panel_bot_stop").classList.add "active"
      document.getElementById("lang_panel_bot_start").classList.remove "active"

    try #setInterval LOGBOX
      setInterval =>
        @LOG = that.requestAjax get_url_log, "GET"
        document.getElementById("LOGBOX").innerHTML = @LOG.replace(/\n/g,'<br />')
      , 1500

    try #addEventListener "click" start
      document.getElementById("lang_panel_bot_start").addEventListener "click", ->
        that.requestAjax set_url_data + """?config.bot.start=true""", "GET"
        if that.checkBotStart()
          document.getElementById("lang_panel_bot_start").classList.add "active"
          document.getElementById("lang_panel_bot_stop").classList.remove "active"
    try #addEventListener "click" stop
      document.getElementById("lang_panel_bot_stop").addEventListener "click", ->
        that.requestAjax set_url_data + """?config.bot.start=false""", "GET"
        that.checkBotStart()
        if !that.checkBotStart()
          document.getElementById("lang_panel_bot_stop").classList.add "active"
          document.getElementById("lang_panel_bot_start").classList.remove "active"
    try #addEventListener "click" on lang_panel_bot_color_save AND SAVE config.BOT.color
      @CONFIG = JSON.parse @requestAjax get_url_config, "GET"
      document.getElementById("admin_0_input_1").value = "#" + @CONFIG.BOT.color
      document.getElementById("lang_panel_bot_color_save").addEventListener "click", ->
        that.requestAjax put_url_config + """?config.bot.color=#{document.getElementById("admin_0_input_1").value.substring(1)}""", "GET"
        document.location = "/#administration"


  # ========================== #
  # Initialised                #
  # "/#stats"                  #
  # ========================== #
  admin_panel_1: ->
    that = @
    # ========================== #
    # Display statistique from   #
    # data file                  #
    # ========================== #
    try
      @FOLLOWER = JSON.parse that.requestAjax get_url_follower, "GET"
      @VIEWER = JSON.parse that.requestAjax get_url_viewer, "GET"
      @MESSAGE = JSON.parse that.requestAjax get_url_message, "GET"
      document.getElementById("panel_stats_follower_total").innerHTML = @FOLLOWER.INFO.follower
      document.getElementById("panel_stats_viewer_total").innerHTML = @VIEWER.INFO.viewer
      document.getElementById("panel_stats_message_total").innerHTML = @MESSAGE.INFO.total
      #setInterval =>
      #  @FOLLOWER = JSON.parse that.requestAjax get_url_follower, "GET"
      #  @VIEWER = JSON.parse that.requestAjax get_url_viewer, "GET"
      #  @MESSAGE = JSON.parse that.requestAjax get_url_message, "GET"
      #  document.getElementById("panel_stats_follower_total").innerHTML = @FOLLOWER.INFO.follower
      #  document.getElementById("panel_stats_viewer_total").innerHTML = @VIEWER.INFO.viewer
      #  document.getElementById("panel_stats_message_total").innerHTML = @MESSAGE.INFO.total
      #, 5000
    # ========================== #
    # addEventListener and add   #
    # to table the new sondage   #
    # ========================== #
    try
      document.getElementById("lang_panel_stats_form_question_add").addEventListener "click", ->
        document.getElementById("panel_stats_table").innerHTML += """
        <tr>
          <th>#{that.LANGUAGE.LANGUAGE.lang_panel_stats_table_question}</th>
          <td>#{document.getElementById("panel_stats_input_1").value}</td>
          <td><i class="fa fa-times" aria-hidden="true"></i></td>
        </tr>
        """
    try
      document.getElementById("lang_panel_stats_form_reponse_add").addEventListener "click", ->
        document.getElementById("panel_stats_table").innerHTML += """
        <tr>
          <th>#{that.LANGUAGE.LANGUAGE.lang_panel_stats_table_reponse}</th>
          <td>#{document.getElementById("panel_stats_input_2").value}</td>
          <td><i class="fa fa-times" aria-hidden="true"></i></td>
        </tr>
        """

  # ========================== #
  # Initialised                #
  # "/#command"                #
  # ========================== #
  admin_panel_2: ->
    that = @

    # ========================== #
    # addEventListener on click  #
    # for add new command or     #
    # event                      #
    # ========================== #
    try
      document.getElementById("lang_panel_command_add").addEventListener "click", ->
        if document.getElementById("panel_command_action_join").checked
          group1 = "onJoin"
        else if document.getElementById("panel_command_action_leave").checked
          group1 = "onLeave"
        else
          group1 = ""
        if document.getElementById("panel_command_command_method_me").checked
          group2 = "Me"
        else if document.getElementById("panel_command_method_chat").checked
          group2 = "Chat"
        else if document.getElementById("panel_command_method_whisper").checked
          group2 = "Whisper"
        else
          group2 = ""

        that.requestAjax set_url_event + """?
        command.event.event=#{group1}&
        command.event.method=#{group2}&
        command.event.message=#{document.getElementById("panel_command_action_message").value}
        """, "GET"
    try
      document.getElementById("lang_panel_command_command_add").addEventListener "click", ->
        if document.getElementById("lang_panel_command_command_modo_check").checked
          user_moderat = true
        if document.getElementById("lang_panel_command_command_user_check").checked
          user_user = true
        if document.getElementById("lang_panel_command_command_owner_check").checked
          user_stramer = true

        if document.getElementById("lang_panel_command_event_me_radio").checked
          group3 = "Me"
        else if document.getElementById("lang_panel_command_event_chat_radio").checked
          group3 = "Chat"
        else if document.getElementById("lang_panel_command_event_whisper_radio").checked
          group3 = "Whisper"
        else
          group3 = ""

        that.requestAjax set_url_command + """?
          command.command.command=#{document.getElementById("panel_command_command_input_1").value}&
          command.command.method=#{group3}&
          command.command.perm.streamer=#{user_stramer || false}&
          command.command.perm.moderato=#{user_moderat || false}&
          command.command.perm.user=#{user_user || false}&
          command.command.message=#{document.getElementById("panel_command_command_input_2").value}
          """, "GET"

    # ========================== #
    # Display table in page      #
    # admin_0.html               #
    #                            #
    # panel_command_command_table#
    # panel_command_event_table  #
    #                            #
    # ========================== #
    try
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
    try
      @EVENT = JSON.parse @requestAjax get_url_event, "GET"
      n = 0
      while n < Object.keys(@EVENT).length
        console.log @EVENT[Object.keys(@EVENT)[n]]
        document.getElementById("panel_command_event_table").innerHTML += """
        <tr>
          <td>#{@EVENT[Object.keys(@EVENT)[n]]['event']}</td>
          <td>#{@EVENT[Object.keys(@EVENT)[n]]['method']}</td>
          <td>#{@EVENT[Object.keys(@EVENT)[n]]['message']}</td>
          <td><i class="fa fa-trash" aria-hidden="true"></i> <i class="fa fa-check-circle-o" aria-hidden="true"></i></td>
        </tr>
        """
        n++

  # ========================== #
  # Initialised on             #
  # "/#administration"         #
  # "/#command"                #
  # "/#stats"                  #
  # ========================== #
  administration: -> #ADMINISTRATION SET
    that = @
    if window.location.hash is """#administration"""
      document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_0.html", "GET"
      that.languageInit()
      that.admin_panel_0()
      document.getElementById("nav_link_admin").classList.add "active"
      document.getElementById("nav_link_stats").classList.remove "active"
      document.getElementById("nav_link_command").classList.remove "active"


    else if window.location.hash is """#stats"""
      document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_1.html", "GET"
      that.languageInit()
      that.admin_panel_1()
      document.getElementById("nav_link_admin").classList.remove "active"
      document.getElementById("nav_link_stats").classList.add "active"
      document.getElementById("nav_link_command").classList.remove "active"

    else if window.location.hash is """#command"""
      document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_2.html", "GET"
      that.languageInit()
      that.admin_panel_2()
      document.getElementById("nav_link_admin").classList.remove "active"
      document.getElementById("nav_link_stats").classList.remove "active"
      document.getElementById("nav_link_command").classList.add "active"

    window.addEventListener "hashchange", -> #EVENT LISTEN WHEN # CHANGE

      if window.location.hash is """#administration"""
        document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_0.html", "GET"
        that.languageInit()
        that.admin_panel_0()
        document.getElementById("nav_link_admin").classList.add "active"
        document.getElementById("nav_link_stats").classList.remove "active"
        document.getElementById("nav_link_command").classList.remove "active"

      else if window.location.hash is """#command"""
        document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_2.html", "GET"
        that.languageInit()
        that.admin_panel_2()
        document.getElementById("nav_link_admin").classList.remove "active"
        document.getElementById("nav_link_stats").classList.remove "active"
        document.getElementById("nav_link_command").classList.add "active"

      else if window.location.hash is """#stats"""
        document.getElementById("admin_MainPanel").innerHTML = that.requestAjax "/model/admin_1.html", "GET"
        that.languageInit()
        that.admin_panel_1()
        document.getElementById("nav_link_admin").classList.remove "active"
        document.getElementById("nav_link_stats").classList.add "active"
        document.getElementById("nav_link_command").classList.remove "active"

  # ========================== #
  # Initialised on             #
  # "/installation/"           #
  # ========================== #
  installation: -> #INSTALLATION SET
    Parsed = JSON.parse @requestAjax get_url_config, "GET"
    if Parsed.OPTION.instalX is Parsed.OPTION.instalXmax
      document.location = "/"

    else if Parsed.OPTION.instalX is "0"
      document.getElementById("installation_instalX").innerHTML = Parsed.OPTION.instalX
      document.getElementById("installation_instalXmax").innerHTML = Parsed.OPTION.instalXmax
      document.getElementById("installation_content").innerHTML = @requestAjax "/model/install_0.html", "GET"
      try
        that = @
        document.getElementById("install_0_arrow").addEventListener "click", ->
          that.requestAjax put_url_config + """?config.option.instalx=1""", "GET" #addEventListener for button
          document.location = "/installation/"

    else if Parsed.OPTION.instalX is "1"
      document.getElementById("installation_instalX").innerHTML = Parsed.OPTION.instalX
      document.getElementById("installation_instalXmax").innerHTML = Parsed.OPTION.instalXmax
      document.getElementById("installation_content").innerHTML = @requestAjax "/model/install_1.html", "GET"
      try
        that = @
        document.getElementById("install_1_arrow").addEventListener "click", ->
          that.requestAjax put_url_config + """?
                                            config.user.chanel=#{document.getElementById("install_1_input").value}
                                            &config.option.instalx=2
                                            """
          document.location = "/installation/"

    else if Parsed.OPTION.instalX is "2"
      document.getElementById("installation_instalX").innerHTML = Parsed.OPTION.instalX
      document.getElementById("installation_instalXmax").innerHTML = Parsed.OPTION.instalXmax
      document.getElementById("installation_content").innerHTML = @requestAjax "/model/install_2.html", "GET"
      try
        that = @
        document.getElementById("install_2_arrow").addEventListener "click", ->
          that.requestAjax put_url_config + """?
                                            config.user.username=#{document.getElementById("install_2_input_1").value}
                                            &config.user.password=#{document.getElementById("install_2_input_2").value}
                                            &config.option.instalx=3
                                            """
          document.location = "/installation/"

    else if Parsed.OPTION.instalX is "3"
      document.getElementById("installation_instalX").innerHTML = Parsed.OPTION.instalX
      document.getElementById("installation_instalXmax").innerHTML = Parsed.OPTION.instalXmax
      document.getElementById("installation_content").innerHTML = @requestAjax "/model/install_3.html", "GET"
      try
        that = @
        document.getElementById("install_3_arrow").addEventListener "click", ->
          that.requestAjax put_url_config + """?
                                            config.bot.color=#{document.getElementById("install_3_input_1").value}
                                            &config.option.instalx=4
                                            """
          document.location = "/installation/"

    else if Parsed.OPTION.instalX is "4"
      document.getElementById("installation_instalX").innerHTML = Parsed.OPTION.instalX
      document.getElementById("installation_instalXmax").innerHTML = Parsed.OPTION.instalXmax
      document.getElementById("installation_content").innerHTML = @requestAjax "/model/install_4.html", "GET"
      try
        that = @
        document.getElementById("install_4_input_1").addEventListener "click", ->
          that.requestAjax put_url_config + """?
                                            config.option.instalx=5
                                            """
          document.location = "/"

  # ========================== #
  # Change language of any     #
  # element                    #
  # getElementById()           #
  # ========================== #
  languageInit: -> #CHANGE LANGUAGE IN HTML CODE
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

  # ========================== #
  # Return true or false for   #
  # all function               #
  # checkBotStart: Start->True #
  # checkBotStart: Stop->False #
  # ========================== #
  checkBotStart: ->
    Parsed = JSON.parse @requestAjax get_url_config, "GET"
    if Parsed.BOT.start
      return true
    else
      return false

  # ========================== #
  # Return true or false for   #
  # all function               #
  # checkInstall: Yes->True    #
  # checkInstall: No->False    #
  # ========================== #
  checkInstall: ->
    Parsed = JSON.parse @requestAjax get_url_config, "GET"
    if Parsed.OPTION.instalX is Parsed.OPTION.instalXmax
      return true
    else
      return false

  # ========================== #
  # Return CODE for every link #
  # ========================== #
  requestAjax: (fun_url, fun_method) -> #REQUEST AJAX METHOD
    xmlHTTP = new XMLHttpRequest()
    xmlHTTP.open fun_method || "GET", fun_url, false
    xmlHTTP.send null
    return xmlHTTP.responseText;#REQUEST FILE FUNCTION

#CALL FUNCTION
TwitchBotStream = new TwitchBotStream()
