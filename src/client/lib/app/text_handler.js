// Generated by CoffeeScript 1.8.0
var text_handler,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

text_handler = (function() {
  function text_handler() {
    this.disconnect = __bind(this.disconnect, this);
    this.error = __bind(this.error, this);
    this.arraybuf_to_string = __bind(this.arraybuf_to_string, this);
    this.set_line_buffer = __bind(this.set_line_buffer, this);
    this.clear_backlog = __bind(this.clear_backlog, this);
    this.scroll_backlog = __bind(this.scroll_backlog, this);
    this.input_handler = __bind(this.input_handler, this);
    this.user_output = __bind(this.user_output, this);
    this.insert = __bind(this.insert, this);
    $("#text-input").on("keydown", this.input_handler);
    this.insert("\t                              _       \n" + "\t   ____ ___  ____  ____      (_)____  \n" + "\t  / __ `__ \\/ __ \\/ __ \\    / / ___/  \n" + "\t / / / / / / /_/ / /_/ /   / (__  )   \n" + "\t/_/ /_/ /_/\\____/\\____(_)_/ /____/    \n" + "\t                       /___/          \n" + "\t====================================\n" + "\tmoo.js version 0.0.1\n\n\n\n\n");
    this.line_buf_length = 50;
    this.scroll_buf_index = 0;
    this.line_buf_index = 0;
    this.line_buf = new Array();
  }

  text_handler.prototype.insert = function(line) {
    var end, end_index, start, start_index, url;
    if (typeof line === "object") {
      line = this.arraybuf_to_string(line);
    }
    start = "<http://";
    end = ">.";
    url = "";
    if (line.indexOf(start) > -1) {
      start_index = line.indexOf(start) + 1;
      end_index = line.indexOf(end);
      if (start_index > end_index) {
        end_index = line.lastIndexOf(end);
        url = line.substring(start_index, end_index);
        line = line.substring(0, start_index - 1);
      } else {
        url = line.substring(start_index, end_index);
        line = line.substring(line.indexOf(end) + 2, line.length);
      }
      if (top.frames["web_frame"] != null) {
        console.log("reload web_frame to " + url);
        top.frames["web_frame"].location = url;
      }
    }
    this.user_output(line);
    return url;
  };

  text_handler.prototype.user_output = function(line) {
    var $log_output;
    $log_output = $("#text-backlog");
    if ($log_output.val() !== '') {
      $log_output.val($log_output.val() + line);
    } else {
      $log_output.val(line);
    }
    return this.scroll_backlog();
  };

  text_handler.prototype.input_handler = function(e) {
    var $text_input, index, input, last;
    $text_input = $("#text-input");
    input = $text_input.val();
    if (e.ctrlKey && e.keyCode === 76) {
      e.preventDefault();
      return this.clear_backlog();
    } else if (e.keyCode === 38) {
      if (this.scroll_buf_index < this.line_buf_index) {
        index = this.line_buf_index - this.scroll_buf_index - 1;
        $text_input.val(this.line_buf[index]);
        if (this.scroll_buf_index < this.line_buf_index - 1) {
          return this.scroll_buf_index++;
        }
      }
    } else if (e.keyCode === 40) {
      if (this.scroll_buf_index > 0) {
        this.scroll_buf_index--;
        index = this.line_buf_index - this.scroll_buf_index - 1;
        return $text_input.val(this.line_buf[index]);
      } else {
        return $text_input.val("");
      }
    } else if (e.keyCode === 13) {
      e.preventDefault();
      if (input === "") {
        input = "\n";
      }
      if (this.line_buf_index < this.line_buf_length) {
        this.line_buf.push(input);
        this.line_buf_index++;
      }
      $text_input.val("");
      telnet_line_out(input);
      this.scroll_buf_index = 0;
      if (this.line_buf.length > this.line_buf_length) {
        this.line_buf.reverse();
        last = this.line_buf.pop();
        return this.line_buf.reverse();
      }
    }
  };

  text_handler.prototype.scroll_backlog = function() {
    var $log;
    $log = $("#text-backlog");
    return $log.scrollTop($log[0].scrollHeight - $log.height());
  };

  text_handler.prototype.clear_backlog = function() {
    var $log, height, newlines, num_newlines;
    $log = $("#text-backlog");
    num_newlines = $log[0].value.split(/\r\n|\r|\n/).length;
    height = $log.height() / parseInt(window.getComputedStyle($log[0]).fontSize);
    newlines = Array(parseInt(height) + 1).join("\n");
    return this.insert(newlines);
  };

  text_handler.prototype.set_line_buffer = function(length) {
    return this.line_buf_length = length;
  };

  text_handler.prototype.arraybuf_to_string = function(buf) {
    return String.fromCharCode.apply(null, new Uint8Array(buf));
  };

  text_handler.prototype.error = function() {
    this.clear_backlog();
    this.user_output("\tAn error occured. ");
    return this.user_output("Please try reloading your browser.\n");
  };

  text_handler.prototype.disconnect = function() {
    this.clear_backlog();
    this.user_output("\tYou have been disconnected from the MUD. ");
    return this.user_output("Please try reloading your browser.\n");
  };

  return text_handler;

})();
