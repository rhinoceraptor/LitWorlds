define ["modals/loginModal", "modals/settingsModal"], (loginModal, settingsModal) ->
	class navbar extends Backbone.View
		el: "#navbar"
		events:
			"click #login-btn": "showLoginModal"
			"click .settings": "showSettingsModal"

		showLoginModal: ->
			new loginModal().render()