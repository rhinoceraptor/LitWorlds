require ["moo_router", "navbar", "moo", "text_handler", "html_handler"], (moo_router, navbar, moo, text_handler, html_handler) ->
  window.App = {}
  App.Views = {}
  App.moo_router = new moo_router
  App.Views.navbar = new navbar
  App.Views.text_handler = new text_handler
  App.Views.html_handler = new html_handler
  Backbone.history.start()
