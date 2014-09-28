###############################################################################
# Disconnect modal dialog
# When the socket is disconnected, this modal dialog will alert
# the user to this fact.
###############################################################################

define ->
	class @disconnect_modal extends Backbone.View
		el: "#disconnect-modal"
		events:
			"click #btn-ok": "ok"

		initialize: (opts) ->
			@$okBtn = @$el.find("#btn-ok")

			$(document).on("keyup checkout", (e) =>
				if e.keyCode is 13
					e.preventDefault()
					@ok()
				if e.keyCode is 27
					e.preventDefault()
					@cancel())

		render: ->
			@$el.modal()
			this

		ok: () =>
			@cleanup()

		cleanup: ->
			$(document).off("keyup checkout")
			@$el.off("click", "#btn-ok")
			@$el.modal "hide"
