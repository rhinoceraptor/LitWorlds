define ->
	class @text_handler extends Backbone.View
		el: ".text-wrapper"
		initialize: ->
			console.log 'hello from text_handler'
			@$el.on "keydown", "#text-mode-input", @input_handler

		insert: (line) ->
			line = @arraybuffer_to_string(line)
			console.log 'insert a line: ' + line
			$logOut = $("#text-mode-backlog")
			# Append to backlog, then erase console
			# If there is no text already, don't add a newline.
			if $logOut.val() isnt ''
				$logOut.val($logOut.val() + '\n' + line)
			else
				$logOut.val($logOut.val() + line)

		input_handler: (e) ->
			console.log e
			if e.keyCode is 13
				console.log("NEW LINE DETECTED!!!")

				input_line = $("#text-mode-input").val()
				console.log "sending: " + input_line
				App.Views.main_view.telnet_line_out(input_line)
		
		arraybuffer_to_string: (buf) ->
			return String.fromCharCode.apply(null, new Uint8Array(buf))

		socket: -> App.Views.main_view.socket