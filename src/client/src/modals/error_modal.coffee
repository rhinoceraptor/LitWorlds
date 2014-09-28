###############################################################################
# error modal dialog
# When the TCP connection on the server side has an issue, this modal dialog
# will alert the user to this fact.
###############################################################################

define ->
	class @error_modal extends Backbone.View
		el: "#error-modal"
		events:
			"click #btn-cancel": "cancel"
			"click #btn-ok": "ok"

		initialize: (opts) ->
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

		hide: ->
			@$el.modal "hide"