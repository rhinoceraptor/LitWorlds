define ->
	class @text_handler extends Backbone.View
		el: ".text-wrapper"
		initialize: ->
			@$el.on "keydown", "#text-mode-input", @input_handler

		insert: (line) ->
			line = @arraybuf_to_string(line)
			$logOut = $("#text-mode-backlog")
			# Append to backlog, then erase console
			# If there is no text already, don't add a newline.
			if $logOut.val() isnt ''
				$logOut.val($logOut.val() + '\n' + line)
			else
				$logOut.val($logOut.val() + line)
			# Scroll the backlog
			$logOut.scrollTop($logOut[0].scrollHeight - $logOut.height())

		input_handler: (e) =>
			if e.keyCode is 13
				e.preventDefault()
				$text_input = $("#text-mode-input")
				input = $text_input.val()
				App.Views.mainView.telnet_line_out(input)
				$text_input.val("")

		
		# socket.io data comes in ArrayBuffer format. We want to convert
		# it to UTF-8 text.
		arraybuf_to_string: (buf) ->
			return String.fromCharCode.apply(null, new Uint8Array(buf))

		socket: -> App.Views.main_view.socket
