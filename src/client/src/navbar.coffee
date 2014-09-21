define ["modals/login_modal", "modals/settings_modal", "moo"], (login_modal, settings_modal, moo) ->
	class navbar extends Backbone.View
		el: "#navbar"
		events:
			"click #login-btn": "showLoginModal"
			"click .settings": "showSettingsModal"
			"click .text-select": "textMode"
			"click .graphic-select": "graphicMode"
			"click .mixed-select": "mixedMode"

		showLoginModal: ->
			new login_modal().render()

		showSettingsModal: ->
			new settings_modal().render()

		textMode: ->
			@setCheckMark("text")
			App.Views.mainView.textMode()

		graphicMode: ->
			@setCheckMark("graphic")
			App.Views.mainView.graphicMode()

		mixedMode: ->
			@setCheckMark("mixed")
			App.Views.mainView.mixedMode()

		# When a mode is selected, we want to add a small black indicator box
		# in the dropdown, and remove the others
		setCheckMark: (mode) ->
			console.log "hello to #{mode}"
			$(".mode-select").removeClass("dropdown-selected")
			$(".#{mode}-select").addClass("dropdown-selected")