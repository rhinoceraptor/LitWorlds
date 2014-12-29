###############################################################################
# text_handler
#
# Responsible for all logic involving text input and output for the user.
###############################################################################
class text_handler
  constructor: ->
    $("#text-input").on("keydown", @input_handler)
    # We have to escape the backslashes, that's why it looks goofy
    @insert("\t                              _       \n" +
        "\t   ____ ___  ____  ____      (_)____  \n" +
        "\t  / __ `__ \\/ __ \\/ __ \\    / / ___/  \n" +
        "\t / / / / / / /_/ / /_/ /   / (__  )   \n" +
        "\t/_/ /_/ /_/\\____/\\____(_)_/ /____/    \n" +
        "\t                       /___/          \n" +
        "\t====================================\n" +
        "\tmoo.js version 0.0.1\n\n\n\n\n")

    @line_buf_length = 50      # programatic limit to backlog
    @scroll_buf_index = 0      # input log scroll index
    @line_buf_index = 0        # line_buf's number of stored lines
    @line_buf = new Array()    # array to store previous entered lines

  insert: (line) =>
    # socket.io returns text as an ArrayBuffer object, convert if needed
    if typeof line is "object"
      line = @arraybuf_to_string(line)

    start = "<http://"         # Start of a URL
    end = ">."                 # end of a URL
    url = ""

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
        line = line.substring(0, start_index - 1)
      else
        url = line.substring(start_index, end_index)
        # Kindly remove the URL from the user's text data stream
        line = line.substring(line.indexOf(end) + 2, line.length)

      # Change the url of the Xpress browser iframe to the new URL, if we
      # are in a standard Xpress session.
      if top.frames["web_frame"]?
        console.log "reload web_frame to " + url
        top.frames["web_frame"].location = url
    @user_output(line)
    # Return the URL for testing
    return url

  user_output: (line) =>
    $log_output = $("#text-backlog")
    # Append to backlog, then erase console
    # If there is no text already, don't add a newline.
    if $log_output.val() isnt ''
      $log_output.val($log_output.val() + line)
    else
      $log_output.val(line)
    @scroll_backlog()

  input_handler: (e) =>
    $text_input = $("#text-input")
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
      # When user is back to start of line_buf array, display blank input area
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

      # Reset the input area and the previous line buffer index
      $text_input.val("")
      # Send the user input to the socket.io output handler in moo.coffee
      telnet_line_out(input)
      @scroll_buf_index = 0

      # The native JS array works as a LIFO stack. To pop the last element we
      # have to reverse it first, pop the element, and reverse it again.
      if @line_buf.length > @line_buf_length
        @line_buf.reverse()
        last = @line_buf.pop()
        @line_buf.reverse()

  # Keep scroll position at bottom of scroll buffer when new text is added
  scroll_backlog: () =>
    $log = $("#text-backlog")
    $log.scrollTop($log[0].scrollHeight - $log.height())

  # Scrolls the backlog such that the backlog is cleared
  clear_backlog: () =>
    $log = $("#text-backlog")
    num_newlines = $log[0].value.split(/\r\n|\r|\n/).length
    height = $log.height() / parseInt(window.getComputedStyle($log[0]).fontSize)
    # Add extra newline to be safe, textareas don't align to line height
    newlines = Array(parseInt(height) + 1).join("\n")
    @insert(newlines)

  set_line_buffer: (length) =>
    @line_buf_length = length

  # socket.io text data comes in ArrayBuffer format. We want to
  # convert it to UTF-8 text.
  arraybuf_to_string : (buf) =>
    return String.fromCharCode.apply(null, new Uint8Array(buf))

  error: () =>
    @clear_backlog()
    @user_output("\tAn error occured. ")
    @user_output("Please try reloading your browser.\n")

  disconnect: () =>
    @clear_backlog()
    @user_output("\tYou have been disconnected from the MUD. ")
    @user_output("Please try reloading your browser.\n")
