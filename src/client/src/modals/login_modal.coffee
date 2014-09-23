define ->
	class @login_modal extends Backbone.View
		el: "#login-modal"
		events:
			"click #btn-cancel": "cancel"
			"click #btn-ok": "ok"

		initialize: (opts) ->
			@$okBtn = @$el.find(".btn-ok")
			@$user = @$el.find(".login-user")
			@$passwd = @$el.find(".login-passwd")

			$(document).on "keyup checkout", (e) =>
				if e.keyCode is 13
					e.preventDefault()
					@ok()
				if e.keyCode is 27
					e.preventDefault()
					@cancel()

			@$user.val("")
			@$passwd.val("")
			@$el.on("shown.bs.modal", () =>
				@$user.focus())

		render: ->
			@$el.modal()
			this

		ok: (e) ->		
			if @$el.find(".login-user").val() is "" or @$el.find(".login-passwd").val() is ""
				@wiggle()
			else
				App.Views.mainView.auth(@$user.val(), @$passwd.val())
				@$el.modal "hide"

		cancel: ->
			@$el.modal "hide"

		wiggle: ->
			len = 20
			i = 0
			while (i < 4)
				@$el.animate({'margin-left': "+=" + (len = -len) + 'px'}, 50)
				i++