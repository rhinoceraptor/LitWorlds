###############################################################################
# text_handler
#
# Responsible for all logic involving text input and output for the user.
###############################################################################

define ->
	class @text_handler extends Backbone.View
		el: ".text-wrapper"
		initialize: ->
			@$el.on "keydown", "#text-mode-input", @input_handler
			@insert("jsMOO version 0.0.1\n" +
					"Copyright (c) 2014, John Lewis, Owen Watson, Tim Cunningham\n" + 
					"All rights reserved.\n" +
					"For license information, go to Options --> Licenses.\n")

			@line_buf_length = 50		# programatic limit to backlog
			@scroll_buf_index = 0		# input log scroll index
			@line_buf_index = 0			# line_buf's number of stored lines
			@line_buf = new Array()		# array to store previous entered lines

		insert: (line) =>
			# socket.io returns text as an ArrayBuffer object
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
			$text_input = $("#text-mode-input")
			input = $text_input.val()

			# Handle ctrl-l clearing
			if e.ctrlKey and e.keyCode is 76
				e.preventDefault()
				@clear_backlog()

			# Up arrow, go up through the previous line buffer
			else if e.keyCode is 38
				if @scroll_buf_index < @line_buf_index
					index = @line_buf_index - @scroll_buf_index - 1
					$text_input.val(@line_buf[index])
					if @scroll_buf_index < @line_buf_index - 1
						@scroll_buf_index++

			# Down arrow, go down through the previous line buffer
			else if e.keyCode is 40
				if @scroll_buf_index > 0
					@scroll_buf_index--
					index = @line_buf_index - @scroll_buf_index - 1
					$text_input.val(@line_buf[index])
				# Once the user goes back to the start of the line_buf array,
				# return them to a blank input area.
				else
					$text_input.val("")

			# Handle newlines/enter key presses
			else if e.keyCode is 13
				e.preventDefault()
				# do nothing if blank string entered
				if input is ""
					return

				# If limit on the line buffer is not reached, push the input
				if @line_buf_index < @line_buf_length
					console.log 'push ' + input
					@line_buf.push(input)
					@line_buf_index++

				# Send the input onto the socket.io logic in moo
				App.Views.mainView.telnet_line_out(input)
				# reset the input area and the previous line buffer index
				$text_input.val("")
				@scroll_buf_index = 0

				# The native JS array works as a LIFO stack. To pop the last
				# element we have to reverse it first, pop the element, and
				# reverse it again.
				if @line_buf.length > @line_buf_length
					@line_buf.reverse()
					last = @line_buf.pop()
					@line_buf.reverse()
					console.log 'pop ' + last

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
