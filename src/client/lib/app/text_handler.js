// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function() {
  return this.text_handler = (function(_super) {
    __extends(text_handler, _super);

    function text_handler() {
      this.set_line_buffer = __bind(this.set_line_buffer, this);
      this.clear_backlog = __bind(this.clear_backlog, this);
      this.input_handler = __bind(this.input_handler, this);
      this.insert = __bind(this.insert, this);
      return text_handler.__super__.constructor.apply(this, arguments);
    }

    text_handler.prototype.el = ".text-wrapper";

    text_handler.prototype.initialize = function() {
      this.$el.on("keydown", "#text-mode-input", this.input_handler);
      this.insert("\t                              _       \n" + "\t   ____ ___  ____  ____      (_)____  \n" + "\t  / __ `__ \\/ __ \\/ __ \\    / / ___/  \n" + "\t / / / / / / /_/ / /_/ /   / (__  )   \n" + "\t/_/ /_/ /_/\\____/\\____(_)_/ /____/    \n" + "\t                       /___/          \n" + "\t====================================\n" + "\tmoo.js version 0.0.1\n" + "\tFor license information, go to " + "Options --> Licenses.\n\tTo connect the MUD, use the " + "Login button or manually log in by pressing Connect.\n");
      this.line_buf_length = 50;
      this.scroll_buf_index = 0;
      this.line_buf_index = 0;
      this.line_buf = new Array();
      this.rooms = new Array();
      return this.links = new Array();
    };

    text_handler.prototype.insert = function(line) {
      var $log_output, end, end_index, login_failed, start, start_index, url;
      if (typeof line === "object") {
        line = this.arraybuf_to_string(line);
      }
      start = "<http://";
      end = ">.";
      login_failed = "Either that player does not exist, or has a different password.";
      if (line.indexOf(start) > -1) {
        start_index = line.indexOf(start) + 1;
        end_index = line.indexOf(end);
        if (start_index > end_index) {
          end_index = line.lastIndexOf(end);
        }
        url = line.substring(start_index, end_index);
        line = line.substring(line.indexOf(end) + 2, line.length);
        App.Views.mainView.request_url(url);
      }
      if (line.indexOf(login_failed) > -1) {
        App.Views.login - modal.fail();
      }
      $log_output = $("#text-mode-backlog");
      if ($log_output.val() !== '') {
        $log_output.val($log_output.val() + line);
      } else {
        $log_output.val(line);
      }
      return this.scroll_backlog();
    };

    text_handler.prototype.input_handler = function(e) {
      var $text_input, index, input, last;
      $text_input = $("#text-mode-input");
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
        App.Views.mainView.telnet_line_out(input);
        $text_input.val("");
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
      $log = $("#text-mode-backlog");
      return $log.scrollTop($log[0].scrollHeight - $log.height());
    };

    text_handler.prototype.clear_backlog = function() {
      var $log, height, newlines, num_newlines;
      $log = $("#text-mode-backlog");
      num_newlines = $log[0].value.split(/\r\n|\r|\n/).length;
      height = parseInt($log.height() / parseInt($log.css("line-height")));
      newlines = Array(height + 1).join("\n");
      return this.insert(newlines);
    };

    text_handler.prototype.set_line_buffer = function(length) {
      return this.line_buf_length = length;
    };

    text_handler.prototype.arraybuf_to_string = function(buf) {
      return String.fromCharCode.apply(null, new Uint8Array(buf));
    };

    return text_handler;

  })(Backbone.View);
});
