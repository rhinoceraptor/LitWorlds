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
      # We have to escape the backslashes, that's why it looks goofy
      @insert("\t                              _       \n" +
          "\t   ____ ___  ____  ____      (_)____  \n" +
          "\t  / __ `__ \\/ __ \\/ __ \\    / / ___/  \n" +
          "\t / / / / / / /_/ / /_/ /   / (__  )   \n" +
          "\t/_/ /_/ /_/\\____/\\____(_)_/ /____/    \n" +
          "\t                       /___/          \n" +
          "\t====================================\n" +
          "\tmoo.js version 0.0.1\n" +
          "\tFor license information, go to " +
          "Options --> Licenses.\n\tTo connect the MUD, use the " +
          "Login button or manually log in by pressing Connect.\n")

      @line_buf_length = 50      # programatic limit to backlog
      @scroll_buf_index = 0      # input log scroll index
      @line_buf_index = 0        # line_buf's number of stored lines
      @line_buf = new Array()    # array to store previous entered lines
      @rooms = new Array()       # array to store the possible rooms to move to
      @links = new Array()       # array to store the possible links to click

    insert: (line) =>
      # socket.io returns text as an ArrayBuffer object
      if typeof line is "object"
        line = @arraybuf_to_string(line)

      start = "<http://"         # Start of a URL
      end = ">."                 # end of a URL
      login_failed = "Either that player does not exist, or has a different password."

      # Did we get a URL with the telnet data?
      # They come in the form <http://domain.tld:7000/123/>.
      if line.indexOf(start) > -1
        # We got a url, so load it for the user
        start_index = line.indexOf(start) + 1
        end_index = line.indexOf(end)

        # Sometimes URLs are the last part of a text segment
        if start_index > end_index
          end_index = line.lastIndexOf(end)
        url = line.substring(start_index, end_index)

        # Kindly remove the URL from the user's text data stream
        line = line.substring(line.indexOf(end) + 2, line.length)
        App.Views.mainView.request_url(url)

      # Did our login fail?
      if line.indexOf(login_failed) > -1
        App.Views.login-modal.fail()

      $log_output = $("#text-mode-backlog")
      # Append to backlog, then erase console
      # If there is no text already, don't add a newline.
      if $log_output.val() isnt ''
        $log_output.val($log_output.val() + line)
      else
        $log_output.val(line)
      @scroll_backlog()

    input_handler: (e) =>
      $text_input = $("#text-mode-input")
      input = $text_input.val()

      # Handle ctrl-l, clear the screen
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
          input = "\n"

        # If limit on the line buffer is not reached, push the input
        if @line_buf_index < @line_buf_length
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

    # Keep the scroll position at the bottom of the scroll buffer when new
    # text is added to it.
    scroll_backlog: () ->
      $log = $("#text-mode-backlog")
      $log.scrollTop($log[0].scrollHeight - $log.height())

    # Scroll the backlog such that the backlog is cleared.
    clear_backlog: () =>
      $log = $("#text-mode-backlog")
      num_newlines = $log[0].value.split(/\r\n|\r|\n/).length
      height = parseInt($log.height() / parseInt($log.css("line-height")))
      # Add one extra newline just to be sure.
      # The text areas don't align in scale exactly to line height
      newlines = Array(height + 1).join("\n")
      @insert(newlines)

    set_line_buffer: (length) =>
      @line_buf_length = length

    # socket.io text data comes in ArrayBuffer format. We want to
    # convert it to UTF-8 text.
    arraybuf_to_string: (buf) ->
      return String.fromCharCode.apply(null, new Uint8Array(buf))
