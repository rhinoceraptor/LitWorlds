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

    # Add the highlight in the dropdown for text mode
    text_mode: ->
      @set_check_mark("text")
      App.Views.mainView.text_mode()

    # Add the highlight in the dropdown for graphic mode
    graphic_mode: ->
      @set_check_mark("graphic")
      App.Views.mainView.graphic_mode()

    # Add the highlight in the dropdown for mixed mode
    mixed_mode: ->
      @set_check_mark("mixed")
      App.Views.mainView.mixed_mode()

    # Connect as a guest to the MOO.
    conn_guest: =>
      # Tell mainView to connect to tell server it's ready
      App.Views.text_handler.insert("\n\n\n")
      App.Views.mainView.auth("guest", "")
      # Toggle the connect button
      @set_btn_disconnect()

    # Change the text of the "Connect as guest" button to "Disconnect".
    # Change the ID from "connect-guest" to "diconnect-btn"
    set_btn_disconnect: ->
      $btn = @$el.find("#connect-guest")
      $btn.attr("id", "disconnect-btn")
      $btn.html("Disconnect")

    # Change the text of the "Disconnect" button to "Connect as guest".
    # Change the ID from "diconnect-btn" to "connect-guest"
    set_btn_connect: () ->
      $btn = @$el.find("#disconnect-btn")
      $btn.attr("id", "connect-guest")
      $btn.html("Connect as guest")

    # Disconnect from the MOO. This function also changes the disconnect button
    # back to the "Connect as guest" button.
    disconnect: () ->
      App.Views.text_handler.clear_backlog()
      App.Views.text_handler.insert("\t\tYou have disconnected from the MUD.\n")
      App.Views.mainView.close()
      App.Views.html_handler.remove_markup()
      # Toggle the connect button
      @set_btn_connect()

    # When a mode is selected, we want to add a small black indicator box
    # in the dropdown, and remove the others
    set_check_mark: (mode) ->
      console.log "hello to #{mode}"
      $(".mode-select").removeClass("dropdown-selected")
      $(".#{mode}-select").addClass("dropdown-selected")
