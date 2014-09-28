define ->
	class @license_modal extends Backbone.View
		el: "#license-modal"
		events:
			"click #btn-ok": "ok"

		render: ->
			@$el.modal()
			this

		ok: ->
			@$el.modal "hide"
