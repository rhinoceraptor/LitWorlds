define ->
	class @text_handler extends Backbone.View
		el: ".text-wrapper"
		initialize: ->
			@$el.on "keydown", "#text-mode-input", @input_handler
			@insert("jsMOO version 0.0.1\n" +
					"Copyright (c) 2014, John Lewis, Owen Watson, Tim Cunningham\n" + 
					"All rights reserved.\n" +
					"For license information, go to Options --> Licenses.\n")

			@line_buf_length = 50
			@line_buf = new Array()

		insert: (line) =>
			if typeof line is "object"
				line= @arraybuf_to_string(line)
			$log_output = $("#text-mode-backlog")
			# Append to backlog, then erase console
			# If there is no text already, don't add a newline.
			if $log_output.val() isnt ''
				$log_output.val($log_output.val() + line)
			else
				$log_output.val($log_output.val() + line)
			@scroll_backlog()

		input_handler: (e) =>
			# Capture all keyboard input, thereby avoiding the browser's use
			# of ctrl-lm it is a keyboard shortcut to highlight the url bar.
			e.preventDefault()
			if e.ctrlKey and e.keyCode is 76
				console.log 'clear it!'
				@clear_backlog()
			else
				@delegateEvents()
			# Handle newlines/enter key presses
			if e.keyCode is 13
				e.preventDefault()
				$text_input = $("#text-mode-input")
				input = $text_input.val()
				App.Views.mainView.telnet_line_out(input)
				$text_input.val("")

		# Keep the scroll position at the bottom of the scroll buffer when new
		# text is added to it.
		scroll_backlog: () ->
			$log_output = $("#text-mode-backlog")
			$log_output.scrollTop($log_output[0].scrollHeight - $log_output.height())

		# Scroll the backlog such that the backlog is cleared.
		clear_backlog: () =>
			$log_output = $("#text-mode-backlog")
			num_newlines = $log_output[0].value.split(/\r\n|\r|\n/).length
			height = parseInt($log_output.height() / parseInt($log_output.css("line-height")))
			# Add one extra newline just to be sure.
			# The text areas don't align in scale to line height
			newlines = Array(height + 1).join("\n")
			@insert(newlines)

		set_line_buffer: (length) =>
			@line_buf_length = length

		# socket.io data comes in ArrayBuffer format. We want to convert
		# it to UTF-8 text.
		arraybuf_to_string: (buf) ->
			return String.fromCharCode.apply(null, new Uint8Array(buf))

		socket: -> App.Views.main_view.socket
