define ->
	class @settings_modal extends Backbone.View
		el: "#settings-modal"
		events:
			"click #btn-cancel": "cancel"
			"click #btn-ok": "ok"

		initialize: (opts) =>
			@$okBtn = @$el.find(".btn-ok")

			$(document).on "keyup checkout", (e) =>
				if e.keyCode is 13
					e.preventDefault()
					@ok()
				if e.keyCode is 27
					e.preventDefault()
					@cancel()

		render: ->
			@$el.modal()
			this

		ok: (e) ->
			length = parseInt(@$el.find(".line-buf")[0].value)
			if length isnt null
				App.Views.mainView.text_handler.set_line_buffer(length)
			@$el.modal "hide"
