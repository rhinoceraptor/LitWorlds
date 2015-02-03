// Generated by CoffeeScript 1.7.1
var test;

test = {};

beforeEach(function() {
  return test.text = new text_handler();
});

afterEach(function() {
  return $("#text-input").unbind();
});

describe('text_handler', function() {
  it('should bind a \'keydown\' event handler to #text-input', function() {
    var event_name;
    event_name = $._data($('#text-input')[0], 'events').keydown[0].type;
    return expect(event_name).toEqual('keydown');
  });
  it('should define an int variable line_buf_length', function() {
    return expect(test.text.line_buf_length).toEqual(jasmine.any(Number));
  });
  it('should define an int variable scroll_buf_index', function() {
    return expect(test.text.scroll_buf_index).toEqual(jasmine.any(Number));
  });
  it('should define an int variable line_buf_index', function() {
    return expect(test.text.line_buf_index).toEqual(jasmine.any(Number));
  });
  it('should define a line buffer array', function() {
    return expect(test.text.line_buf.constructor).toEqual(Array);
  });
  it('should correctly parse URLs at the beginning of text blocks', function() {
    var data, new_url;
    data = "<http://mydomain.tld/123>. This is a stream of data coming from enCore DB running on LambdaMOO. This particular test stream has a URL at the beginning of the stream. The insert function will return just the URL.";
    new_url = test.text.insert(data);
    return expect(new_url).toEqual("http://mydomain.tld/123");
  });
  it('should correctly parse URLs at the end of text blocks', function() {
    var data, new_url;
    data = "This is a stream of data coming from enCore DB on LambdaMOO. This particular test stream has a URL at the end of the stream. The insertfunction will return just the URL. <http://mydomain.tld/123>.";
    new_url = test.text.insert(data);
    return expect(new_url).toEqual("http://mydomain.tld/123");
  });
  it('should output to the user', function() {
    var output_str, test_str;
    test_str = "This should be presented to the user";
    test.text.user_output(test_str);
    output_str = $("#text-backlog")[0].value;
    return expect(output_str.indexOf(test_str, output_str.length - test_str.length)).not.toEqual(-1);
  });
  it('should set the line buffer', function() {
    return expect(test.text.set_line_buffer(5)).toEqual(5);
  });
  it('should return a string from a buffer array', function() {
    var inArr, res;
    inArr = [65, 66, 67];
    res = test.text.arraybuf_to_string(inArr);
    return expect(res).toEqual("ABC");
  });
  it('should show an error message when prompted', function() {
    var err_str, output_str;
    test.text.error();
    err_str = "\tAn error occured. Please try reloading your browser.\n";
    output_str = $("#text-backlog")[0].value;
    return expect(output_str.indexOf(err_str, output_str.length - err_str.length)).not.toEqual(-1);
  });
  it('should show an disconnect message when prompted', function() {
    var disc_str, output_str;
    test.text.disconnect();
    disc_str = "\tYou have been disconnected from the MUD. Please try reloading your browser.\n";
    output_str = $("#text-backlog")[0].value;
    return expect(output_str.indexOf(disc_str, output_str.length - disc_str.length)).not.toEqual(-1);
  });
  it('should call clear_backlog() when ctrl + L is pressed', function() {
    var e;
    spyOn(test.text, "clear_backlog");
    e = $.Event("keydown", {
      keyCode: 76,
      ctrlKey: true
    });
    $("#text-input").trigger(e);
    return expect(test.text.clear_backlog).toHaveBeenCalled();
  });
  it('should go up through the previous line buffer', function() {
    var e, line_val;
    test.text.line_buf.push("line 1");
    test.text.line_buf.push("line 2");
    test.text.line_buf.push("line 3");
    test.text.line_buf_index += 3;
    e = $.Event("keydown", {
      keyCode: 38
    });
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    expect(line_val).toEqual("line 3");
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    expect(line_val).toEqual("line 2");
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    return expect(line_val).toEqual("line 1");
  });
  it('should go down through the previous line buffer', function() {
    var e, line_val;
    test.text.line_buf_index = 0;
    test.text.line_buf.push("line 1");
    test.text.line_buf.push("line 2");
    test.text.line_buf.push("line 3");
    test.text.line_buf_index += 3;
    e = $.Event("keydown", {
      keyCode: 40
    });
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    expect(line_val).toEqual("");
    test.text.scroll_buf_index = 3;
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    expect(line_val).toEqual("line 1");
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    expect(line_val).toEqual("line 2");
    $("#text-input").trigger(e);
    line_val = $("#text-input").val();
    return expect(line_val).toEqual("line 3");
  });
  it("should call telnet_line_out when enter is pressed", function() {
    var e;
    spyOn(window, "telnet_line_out");
    $("#text-input").val("This line is to be sent to telnet_line_out");
    e = $.Event("keydown", {
      keyCode: 13
    });
    $("#text-input").trigger(e);
    return expect(window.telnet_line_out).toHaveBeenCalledWith("This line is to be sent to telnet_line_out");
  });
  it("should send '\\n' if text-input is empty when entered is pressed", function() {
    var e;
    spyOn(window, "telnet_line_out");
    $("#text-input").val("");
    e = $.Event("keydown", {
      keyCode: 13
    });
    $("#text-input").trigger(e);
    expect(window.telnet_line_out).toHaveBeenCalledWith("\n");
    return $("#text-input").unbind();
  });
  it("should push input to the line_buf when enter is pressed", function() {
    var e, str;
    str = "This is a test line to enter into the line_buf";
    expect(test.text.line_buf_index).toEqual(0);
    $("#text-input").val(str);
    e = $.Event("keydown", {
      keyCode: 13
    });
    $("#text-input").trigger(e);
    expect(test.text.line_buf_index).toEqual(1);
    expect(test.text.line_buf[0]).toEqual(str);
    return $("#text-input").unbind();
  });
  it("should pop an item off the lin_buf when its length exceeds line_buf_length", function() {
    var e;
    test.text.line_buf_length = 3;
    test.text.line_buf.push("Line 1");
    test.text.line_buf.push("Line 2");
    test.text.line_buf.push("Line 3");
    test.text.line_buf_index = 3;
    $("#text-input").val("Line 4");
    e = $.Event("keydown", {
      keyCode: 13
    });
    $("#text-input").trigger(e);
    expect(test.text.line_buf_index).toEqual(3);
    expect(test.text.line_buf.length).toEqual(3);
    expect(test.text.line_buf[0]).toEqual("Line 2");
    return expect(test.text.line_buf[2]).toEqual("Line 4");
  });
  return it("should call scroll_backlog in user_output", function() {
    spyOn(test.text, "scroll_backlog");
    test.text.user_output("Test line output");
    return expect(test.text.scroll_backlog).toHaveBeenCalled();
  });
});
