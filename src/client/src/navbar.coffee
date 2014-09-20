define ["modals/loginModal", "modals/settingsModal", "moo"], (loginModal, settingsModal, moo) ->
	class navbar extends Backbone.View
		el: "#navbar"
		events:
			"click #login-btn": "showLoginModal"
			"click .settings": "showSettingsModal"
			"click .text-select": "textMode"
			"click .graphic-select": "graphicMode"
			"click .mixed-select": "mixedMode"

		showLoginModal: ->
			new loginModal().render()

		showSettingsModal: ->
			new settingsModal().render()

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