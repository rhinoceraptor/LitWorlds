require ["moo_router", "navbar"], (moo_router, navbar) ->
	window.App = {}
	App.Views = {}
	App.moo_router = new moo_router
	App.Views.navbar = new navbar
	App.Views.mainView = new moo
	Backbone.history.start()
