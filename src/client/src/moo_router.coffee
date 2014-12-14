###############################################################################
# Backbone.JS router class
###############################################################################

define ["moo"], (moo) ->
  class moo_router extends Backbone.Router
    routes:
      "*other": "moo"

    moo: (param) ->
      # If the page is already loaded, avoid rendering moo
      # Param will be a URL encoded string with the login string from encore
      if not App.Views.mainView?
        App.Views.mainView = new moo
        App.Views.mainView.render(param)
