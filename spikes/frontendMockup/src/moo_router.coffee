###############################################################################
# Backbone.JS router class
###############################################################################

define ["moo"], (moo) ->
	class moo_router extends Backbone.Router
		# When a hash fragment URL is accessed, we want to show the user the
		# correct view mode in the application
		routes:
			"#text": "text_mode"
			"#mixed": "mixed_mode"
			"#graphic": "graphic_mode"
			"*other": "moo"

		moo: ->
			#App.Views.mainView = new moo
			moo.views.main_view.render()

		text_mode: ->
			console.log "text_mode"
			App.Views.main_view.text_mode()
		mixed_mode: ->
			console.log "mixed_mode"
			App.Views.main_view.mixed_mode()
		graphic_mode: ->
			console.log "graphic_mode"
			App.Views.main_view.graphic_mode()

		window.App = {}
		App.Views = {}
		App.Router = new moo_router
		App.Views.navbar = new navbar
		App.Views.mainView = new moo
		App.Views.mainView.render()

		Backbone.history.start()
