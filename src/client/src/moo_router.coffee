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
			App.Views.mainView.render()

		text_mode: ->
			console.log "text_mode"
			App.Views.mainView.text_mode()
		mixed_mode: ->
			console.log "mixed_mode"
			App.Views.mainView.mixed_mode()
		graphic_mode: ->
			console.log "graphic_mode"
			App.Views.mainView.graphic_mode()
