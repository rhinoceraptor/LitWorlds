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
      "click #connect-guest": "conn_guest"
      "click #disconnect-btn": "disconnect"
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

    # Connect as a guest to the MOO.
    # Change the ID of the "Connect as guest" button to "Disconnect".
    conn_guest: =>
      $connect_btn = @$el.find("#connect-guest")
      connect = $.trim($connect_btn.html())
      if connect is "Connect as guest"
        $connect_btn.attr("id", "disconnect-btn")
        $connect_btn.html("Disconnect")

      # Tell mainView to connect to tell server it's ready
      App.Views.text_handler.insert("\n\n\n")
      App.Views.mainView.auth("guest", "")

    # Disconnect from the MOO. This function also changes the disconnect button
    # back to the "Connect as guest" button.
    disconnect: () ->
      $disconnect_btn = @$el.find("#disconnect-btn")
      disconnect = $.trim($disconnect_btn.html())
      if disconnect is "Disconnect"
        App.Views.mainView.close()
        $disconnect_btn.attr("id", "connect-guest")
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
