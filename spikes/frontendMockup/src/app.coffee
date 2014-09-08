require ["moo_router", "navbar"], (moo_router, navbar) ->
	console.log "app!"
	window.App = {}
	App.Views = {}
	App.Router = new moo_router
	App.Views.Navbar = new navbar
	App.Views.main_view = new moo

	Backbone.history.start()