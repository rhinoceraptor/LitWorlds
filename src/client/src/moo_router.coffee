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
			"#login": "login"
			"#settings": "settings"
			"#*license": "license"
			"*other": "moo"			# default route, renders the moo view

		moo: ->
			# If the user is simply accessing a hash URL, avoid rendering moo
			if not App.Views.mainView?
				App.Views.mainView = new moo
				App.Views.mainView.render()

		text_mode: ->
			#@moo()
			console.log "text_mode"
			App.Views.mainView.text_mode()
		mixed_mode: ->
			#@moo()
			console.log "mixed_mode"
			App.Views.mainView.mixed_mode()
		graphic_mode: ->
			#@moo()
			console.log "graphic_mode"
			App.Views.mainView.graphic_mode()
		license: ->
			#@moo()
			console.log "license"
			App.Views.navbar.show_license_modal()
		login: ->
			#@moo()
			console.log "login"
			App.Views.navbar.show_login_modal()
		settings: ->
			#@moo()
			console.log "settings"
			App.Views.navbar.show_settings_modal()
