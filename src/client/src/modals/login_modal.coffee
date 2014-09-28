define ->
	class @login_modal extends Backbone.View
		el: "#login-modal"
		events:
			"click #btn-cancel": "cancel"
			"click #btn-ok": "ok"
			"click #btn-guest": "guest"

		initialize: (opts) ->
			@$okBtn = @$el.find("#btn-ok")
			@$user = @$el.find(".login-user")
			@$passwd = @$el.find(".login-passwd")

			$(document).on("keyup checkout", (e) =>
				if e.keyCode is 13
					e.preventDefault()
					@ok()
				if e.keyCode is 27
					e.preventDefault()
					@cancel())

			@$user.val("")
			@$passwd.val("")
			@$el.on("shown.bs.modal", () =>
				@$user.focus())

		render: ->
			@$el.modal("show")
			this

		ok: (e) =>	
			console.log 'login ok'	
			if @$el.find(".login-user").val() is "" or @$el.find(".login-passwd").val() is ""
				@wiggle()
				return
			else
				App.Views.mainView.auth(@$user.val(), @$passwd.val())
				@cleanup()

		guest: () =>
			App.Views.mainView.auth("guest", "")
			@cleanup()

		cancel: =>
			@cleanup()

		wiggle: ->
			len = 20
			i = 0
			while (i < 4)
				@$el.animate({'margin-left': "+=" + (len = -len) + 'px'}, 50)
				i++

		# Remove backbone event handlers from el and hide modal
		cleanup: () =>
			$(document).off("keyup checkout")
			@$el.off("click", "#btn-cancel")
			@$el.off("click", "#btn-ok")
			@$el.off("click", "#btn-guest")
