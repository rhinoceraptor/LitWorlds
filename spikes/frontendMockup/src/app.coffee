require ["router", "navbar"], (router, navbar) ->
	console.log "app!"
	window.App = {}
	App.Views = {}
	App.Router = new router
	App.Views.Navbar = new navbar

	Backbone.history.start()