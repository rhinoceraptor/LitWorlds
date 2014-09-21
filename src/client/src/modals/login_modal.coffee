define ->
	class @login_modal extends Backbone.View
		el: "#login-modal"
		events:
			"click #btn-cancel": "cancel"
			"click #btn-ok": "ok"
			"click #btn-guest": "guest"

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

		# Log in as guest
		guest: () ->
			App.Views.mainView.auth("guest", "")

		# Log in with the specified credentials
		ok: (e) =>
			# If the user hits ok with blank credentials, wiggle the window,
			# and focus either the user or passwd fields
			if @$user.val() is "" or @$user.passwd is ""
				if @$user.val() is ""
					@$user.focus()
				else if @$passwd.val is ""
					@$passwd.focus()
				@wiggle()
			# Else, call auth() in moo.coffee
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
