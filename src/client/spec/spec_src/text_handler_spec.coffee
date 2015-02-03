test = {}

beforeEach ->
  test.text = new text_handler()
# Clean up the event handlers attached to #text-input
afterEach ->
  $("#text-input").unbind()

describe 'text_handler', ->
  # Test the constructor for the text_handler class
  it 'should bind a \'keydown\' event handler to #text-input', ->
    event_name = $._data($('#text-input')[0], 'events').keydown[0].type
    expect(event_name).toEqual('keydown')

  it 'should define an int variable line_buf_length', ->
    expect(test.text.line_buf_length).toEqual(jasmine.any(Number))

  it 'should define an int variable scroll_buf_index', ->
    expect(test.text.scroll_buf_index).toEqual(jasmine.any(Number))

  it 'should define an int variable line_buf_index', ->
    expect(test.text.line_buf_index).toEqual(jasmine.any(Number))

  it 'should define a line buffer array', ->
    expect(test.text.line_buf.constructor).toEqual(Array)

  # Test the insert function
  it 'should correctly parse URLs at the beginning of text blocks', ->
    data = "<http://mydomain.tld/123>. This is a stream of data coming from \
    enCore DB running on LambdaMOO. This particular test stream has a URL at \
    the beginning of the stream. The insert function will return just the URL."

    new_url = test.text.insert(data)
    expect(new_url).toEqual("http://mydomain.tld/123")

  it 'should correctly parse URLs at the end of text blocks', ->
    data = "This is a stream of data coming from enCore DB on LambdaMOO. \
    This particular test stream has a URL at the end of the stream. The insert\
     function will return just the URL. <http://mydomain.tld/123>."

    new_url = test.text.insert(data)
    expect(new_url).toEqual("http://mydomain.tld/123")

  it 'should output to the user', ->
    test_str = "This should be presented to the user"
    test.text.user_output(test_str)
    output_str = $("#text-backlog")[0].value
    expect(output_str.indexOf(test_str, output_str.length - test_str.length)).not.toEqual(-1)

  it 'should set the line buffer', ->
    expect(test.text.set_line_buffer(5)).toEqual(5)

  it 'should return a string from a buffer array', ->
    inArr = [65, 66, 67]
    res = test.text.arraybuf_to_string(inArr)
    expect(res).toEqual("ABC")

  it 'should show an error message when prompted', ->
    test.text.error()
    err_str = "\tAn error occured. Please try reloading your browser.\n"
    output_str = $("#text-backlog")[0].value
    expect(output_str.indexOf(err_str, output_str.length - err_str.length)).not.toEqual(-1)

  it 'should show an disconnect message when prompted', ->
    test.text.disconnect()
    disc_str = "\tYou have been disconnected from the MUD. Please try reloading your browser.\n"
    output_str = $("#text-backlog")[0].value
    expect(output_str.indexOf(disc_str, output_str.length - disc_str.length)).not.toEqual(-1)

  it 'should call clear_backlog() when ctrl + L is pressed', ->
    spyOn(test.text, "clear_backlog")
    e = $.Event("keydown", {keyCode: 76, ctrlKey: true})
    $("#text-input").trigger(e)
    expect(test.text.clear_backlog).toHaveBeenCalled()

  it 'should go up through the previous line buffer', ->
    # populate line_buf
    test.text.line_buf.push("line 1")
    test.text.line_buf.push("line 2")
    test.text.line_buf.push("line 3")
    test.text.line_buf_index += 3
    
    # setup keydown event for up arrow
    e = $.Event("keydown", {keyCode: 38})
    $("#text-input").trigger(e)
    # Press up arrow 3 times checking value after each
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 3")

    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 2")

    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 1")

  it 'should go down through the previous line buffer', ->
    # Populate line_buf
    test.text.line_buf_index = 0
    test.text.line_buf.push("line 1")
    test.text.line_buf.push("line 2")
    test.text.line_buf.push("line 3")
    test.text.line_buf_index += 3

    # Setup keydown event for down arrow
    e = $.Event("keydown", {keyCode: 40})

    # With a line_buf_index = 0, no value should be put into text-input
    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("")

    test.text.scroll_buf_index = 3
    
    # Press down arrow three times checking value after each
    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 1")
    
    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 2")

    $("#text-input").trigger(e)
    line_val = $("#text-input").val()
    expect(line_val).toEqual("line 3")

  it "should call telnet_line_out when enter is pressed", ->
    spyOn(window,"telnet_line_out")
    $("#text-input").val("This line is to be sent to telnet_line_out")

    e = $.Event("keydown", {keyCode: 13})
    $("#text-input").trigger(e)
    expect(window.telnet_line_out).toHaveBeenCalledWith("This line is to be sent to telnet_line_out")

  it "should send '\\n' if text-input is empty when entered is pressed", ->
    spyOn(window, "telnet_line_out")
    $("#text-input").val("")

    e = $.Event("keydown", {keyCode: 13})
    $("#text-input").trigger(e)
    expect(window.telnet_line_out).toHaveBeenCalledWith("\n")

  it "should push input to the line_buf when enter is pressed", ->
    str = "This is a test line to enter into the line_buf"
    expect(test.text.line_buf_index).toEqual(0)
    $("#text-input").val(str)

    e = $.Event("keydown", {keyCode: 13})
    $("#text-input").trigger(e)
    expect(test.text.line_buf_index).toEqual(1)
    expect(test.text.line_buf[0]).toEqual(str)

  it "should pop an item off the lin_buf when its length exceeds line_buf_length", ->
    test.text.line_buf_length = 3
    test.text.line_buf.push("Line 1")
    test.text.line_buf.push("Line 2")
    test.text.line_buf.push("Line 3")
    test.text.line_buf_index = 3

    $("#text-input").val("Line 4")
    e = $.Event("keydown", {keyCode: 13})
    $("#text-input").trigger(e)

    expect(test.text.line_buf_index).toEqual(3)
    expect(test.text.line_buf.length).toEqual(3)
    expect(test.text.line_buf[0]).toEqual("Line 2")
    expect(test.text.line_buf[2]).toEqual("Line 4")

  it "should call scroll_backlog in user_output", ->
    spyOn(test.text,"scroll_backlog")
    test.text.user_output("Test line output")
    expect(test.text.scroll_backlog).toHaveBeenCalled()

