define ["modals/login_modal", \
"modals/settings_modal", \
"modals/license_modal"],
(login_modal,
settings_modal,
license_modal) ->
  class navbar extends Backbone.View
    el: "#navbar"
    events:
      "click #login-btn": "show_login_modal"
      "click .settings": "show_settings_modal"
      "click .text-select": "text_mode"
      "click .graphic-select": "graphic_mode"
      "click .mixed-select": "mixed_mode"
      "click #connect-btn": "ready"
      "click #disconnect-btn": "close"
      "click .license": "show_license_modal"

    show_login_modal: ->
      new login_modal().render()

    show_settings_modal: ->
      new settings_modal().render()

    show_license_modal: () ->
      new license_modal().render()

    text_mode: ->
      @set_check_mark("text")
      App.Views.mainView.text_mode()

    graphic_mode: ->
      @set_check_mark("graphic")
      App.Views.mainView.graphic_mode()

    mixed_mode: ->
      @set_check_mark("mixed")
      App.Views.mainView.mixed_mode()

    ready: =>
      $connect_btn = @$el.find("#connect-btn")
      connect = $.trim($connect_btn.html())
      if connect is "Connect as guest"
        $connect_btn.attr("id", "disconnect-btn")
        $connect_btn.html("Disconnect")


      App.Views.mainView.ready()
      App.Views.text_handler.insert("\n\n\n")
      App.Views.mainView.telnet_line_out("co guest")
      App.Views.html_handler.ready()

    close: () ->
      $disconnect_btn = @$el.find("#disconnect-btn")
      disconnect = $.trim($disconnect_btn.html())
      if disconnect is "Disconnect"
        App.Views.mainView.close()
        $disconnect_btn.attr("id", "connect-btn")
        $disconnect_btn.html("Connect as guest")
        App.Views.text_handler.clear_backlog()
        App.Views.text_handler.insert("\t\tYou have disconnected from the MUD.\n")
      App.Views.html_handler.remove_markup()

    # When a mode is selected, we want to add a small black indicator box
    # in the dropdown, and remove the others
    set_check_mark: (mode) ->
      console.log "hello to #{mode}"
      $(".mode-select").removeClass("dropdown-selected")
      $(".#{mode}-select").addClass("dropdown-selected")
