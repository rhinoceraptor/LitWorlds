require ["moo_router", "navbar"], (moo_router, navbar) ->
	console.log "app!"
	window.App = {}
	App.Views = {}
	App.Views.mainView = new moo
	App.Router = new moo_router
	App.Views.navbar = new navbar

	Backbone.history.start()
