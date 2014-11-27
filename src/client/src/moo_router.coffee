###############################################################################
# Backbone.JS router class
###############################################################################

define ["moo"], (moo) ->
  class moo_router extends Backbone.Router
    # When a hash fragment URL is accessed, we want to show the user the
    # correct view mode in the application
    routes:
      "": "moo"
      "text": "text_mode"
      "mixed": "mixed_mode"
      "graphic": "graphic_mode"
      "login": "login"
      "settings": "settings"
      "*other": "moo"

    moo: (param) ->
      # If the page is already loaded, avoid rendering moo
      if not App.Views.mainView?
        App.Views.mainView = new moo
        App.Views.mainView.render()

      # param for #encore/123 will be encore/123
      if param? and param.indexOf("encore") > 0
        console.log ">>>>>" + param
      # The *other route will pick up the "*-license" series of
      # hash URLs used for the licenses. If the hash URL contains
      # license, show the license modal.
      if param? and param.indexOf("license") > 0
        @license()

    text_mode: ->
      @moo()
      App.Views.navbar.text_mode()
    mixed_mode: ->
      @moo()
      App.Views.navbar.mixed_mode()
    graphic_mode: ->
      @moo()
      App.Views.navbar.graphic_mode()
    license: ->
      console.log "license"
      App.Views.navbar.show_license_modal()
    login: ->
      @moo()
      console.log "login"
      App.Views.navbar.show_login_modal()
    settings: ->
      @moo()
      console.log "settings"
      App.Views.navbar.show_settings_modal()
