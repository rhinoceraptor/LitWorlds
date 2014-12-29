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

  it 'should show an error message when prompted', ->

  it 'should show an disconnect message when prompted', ->