test = {}

beforeEach ->
  test.text = new text_handler()

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
    backlog = test.text.user_output("This should be presented to the user")
    expect(backlog.val().endsWith("This should be presented to the user")).toEqual(true)

  it 'should set the line buffer', ->
    expect(test.text.set_line_buffer(5)).toEqual(5)

  it 'should return a string from a buffer array', ->
    inArr = [65, 66, 67]
    res = test.text.arraybuf_to_string(inArr)
    expect(res).toEqual("ABC")

  it 'should show an error message when prompted', ->
    backlog = test.text.error()
    expect(backlog.val().endsWith("\tAn error occured. Please try reloading your browser.\n")).toEqual(true)

  it 'should show an disconnect message when prompted', ->
    backlog = test.text.disconnect()
    expect(backlog.val().endsWith("\tYou have been disconnected from the MUD. Please try reloading your browser.\n")).toEqual(true)

  it 'should call clear_backlog() when ctrl + L is pressed', ->
    spyOn(test.text,"clear_backlog")
    e = document.createEvent('KeyboardEvent')
    e.initKeyEvent('keydown',true,true,window,true,false,false,false,76,0)
    test.text.input_handler(e)
    expect(test.text.clear_backlog).toHaveBeenCalled()

  it 'should go up through the previous line buffer', ->
    #populate line_buf
    test.text.line_buf.push("line 1")
    test.text.line_buf.push("line 2")
    test.text.line_buf.push("line 3")
    test.text.line_buf_index += 3
    
    #setup keydown event for up arrow
    up = document.createEvent('KeyboardEvent')
    up.initKeyEvent('keydown',true,true,window,false,false,false,false,38,0)
    
    #Press up arrow 3 times checking value after each
    test.text.input_handler(up)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 3")

    test.text.input_handler(up)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 2")

    test.text.input_handler(up)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 1")

  it 'should go down through the previous line buffer', ->
    #populate line_buf
    test.text.line_buf.push("line 1")
    test.text.line_buf.push("line 2")
    test.text.line_buf.push("line 3")
    test.text.line_buf_index += 3   

    #setup keydown event for down arrow
    down = document.createEvent('KeyboardEvent')
    down.initKeyEvent('keydown',true,true,window,false,false,false,false,40,0)
    
    # with a line_buf_index = 0, no value should be put into text-input
    test.text.input_handler(down)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("")

    test.text.scroll_buf_index = 3
    
    #Press down arrow three times checking value after each
    test.text.input_handler(down)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 1")
    
    test.text.input_handler(down)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 2")

    test.text.input_handler(down)
    lineVal = $("#text-input").val()
    expect(lineVal).toEqual("line 3")

  it "should call telnet_line_out when enter is pressed", ->
    spyOn(window,"telnet_line_out")
    $("#text-input").val("This line is to be sent to telnet_line_out")

    enter = document.createEvent('KeyboardEvent')
    enter.initKeyEvent('keydown',true,true,window,false,false,false,false,13,0)

    test.text.input_handler(enter)
    expect(window.telnet_line_out).toHaveBeenCalledWith("This line is to be sent to telnet_line_out")

  it "should send '\\n' if text-input is empty when entered is pressed", ->
    spyOn(window,"telnet_line_out")
    $("#text-input").val("")

    enter = document.createEvent('KeyboardEvent')
    enter.initKeyEvent('keydown',true,true,window,false,false,false,false,13,0)

    test.text.input_handler(enter)
    expect(window.telnet_line_out).toHaveBeenCalledWith("\n")

  it "should push input to the line_buf when enter is pressed", ->
    $("#text-input").val("This is a test line to enter into the line_buf")
    expect(test.text.line_buf_index).toEqual(0)

    enter = document.createEvent('KeyboardEvent')
    enter.initKeyEvent('keydown',true,true,window,false,false,false,false,13,0)
    test.text.input_handler(enter)

    expect(test.text.line_buf_index).toEqual(1)
    expect(test.text.line_buf[0]).toEqual("This is a test line to enter into the line_buf")

  it "should pop an item off the lin_buf when its length exceeds line_buf_length", ->
    test.text.line_buf_length = 3
    test.text.line_buf.push("Line 1")
    test.text.line_buf.push("Line 2")
    test.text.line_buf.push("Line 3")
    test.text.line_buf_index = 3

    $("#text-input").val("Line 4")
    enter = document.createEvent('KeyboardEvent')
    enter.initKeyEvent('keydown',true,true,window,false,false,false,false,13,0)
    test.text.input_handler(enter)

    expect(test.text.line_buf_index).toEqual(3)
    expect(test.text.line_buf.length).toEqual(3)
    expect(test.text.line_buf[0]).toEqual("Line 2")
    expect(test.text.line_buf[2]).toEqual("Line 4")

  it "should call scroll_backlog in user_output", ->
    spyOn(test.text,"scroll_backlog")
    test.text.user_output("Test line output")
    expect(test.text.scroll_backlog).toHaveBeenCalled()