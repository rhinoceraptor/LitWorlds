define ["modals/login_modal", "modals/settings_modal", "moo"], (login_modal, settings_modal, moo) ->
	class navbar extends Backbone.View
		el: "#navbar"
		events:
			"click #login-btn": "show_login_modal"
			"click .settings": "show_settings_modal"
			"click .text-select": "text_mode"
			"click .graphic-select": "graphic_mode"
			"click .mixed-select": "mixed_mode"

		show_login_modal: ->
			new login_modal().render()

		show_settings_modal: ->
			new settings_modal().render()

		text_mode: ->
			@set_check_mark("text")
			App.Views.mainView.text_mode()

		graphic_mode: ->
			@set_check_mark("graphic")
			App.Views.mainView.graphic_mode()

		mixed_mode: ->
			@set_check_mark("mixed")
			App.Views.mainView.mixed_mode()

		# When a mode is selected, we want to add a small black indicator box
		# in the dropdown, and remove the others
		set_check_mark: (mode) ->
			console.log "hello to #{mode}"
			$(".mode-select").removeClass("dropdown-selected")
			$(".#{mode}-select").addClass("dropdown-selected")