// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["modals/disconnect_modal", "modals/error_modal", "modals/login_modal", "modals/settings_modal"], function(disconnect_modal, error_modal, login_modal, settings_modal) {
  var moo;
  return moo = (function(_super) {
    __extends(moo, _super);

    function moo() {
      this.request_markup = __bind(this.request_markup, this);
      this.handle_markup = __bind(this.handle_markup, this);
      this.telnet_line_out = __bind(this.telnet_line_out, this);
      this.telnet_line_in = __bind(this.telnet_line_in, this);
      this.close = __bind(this.close, this);
      this.auth = __bind(this.auth, this);
      return moo.__super__.constructor.apply(this, arguments);
    }

    moo.prototype.el = ".main-body";

    moo.prototype.initialize = function() {
      this.socket = io.connect("http://127.0.0.1:8080" || location.host);
      this.socket.on('connect', function() {
        return console.log('connected to socket');
      });
      this.socket.on('disconnect', this.disconnect);
      this.socket.on('error', this.error);
      this.socket.on('tcp_line', this.telnet_line_in);
      return this.socket.on('markup', this.handle_markup);
    };

    moo.prototype.render = function() {
      return console.log('rendering!');
    };

    moo.prototype.disconnect = function() {
      return new disconnect_modal().render();
    };

    moo.prototype.error = function(e) {
      return new error_modal().render(e);
    };

    moo.prototype.ready = function() {
      return this.socket.emit('ready');
    };

    moo.prototype.reconnect = function() {
      return this.connect.hide();
    };

    moo.prototype.text_mode = function() {
      console.log('text_mode');
      $(".text-wrapper").css({
        "display": "inline"
      });
      $(".text-wrapper").removeClass("col-xs-6");
      $(".text-wrapper").addClass("col-xs-12");
      $(".html-wrapper").css({
        "display": "none"
      });
      $(".html-nav-bar").css({
        "display": "none"
      });
      $(".html-wrapper").removeClass("col-xs-6");
      return $(".html-wrapper").removeClass("col-xs-12");
    };

    moo.prototype.graphic_mode = function() {
      console.log('graphic_mode');
      $(".html-wrapper").css({
        "display": "inline"
      });
      $(".html-nav-bar").css({
        "display": "block"
      });
      $(".html-wrapper").removeClass("col-xs-6");
      $(".html-wrapper").addClass("col-xs-12");
      $(".text-wrapper").css({
        "display": "none"
      });
      $(".text-wrapper").removeClass("col-xs-6");
      return $(".text-wrapper").removeClass("col-xs-12");
    };

    moo.prototype.mixed_mode = function() {
      console.log('mixed_mode');
      $(".html-wrapper").css({
        "display": "inline"
      });
      $(".text-wrapper").css({
        "display": "inline"
      });
      $(".html-nav-bar").css({
        "display": "block"
      });
      $(".html-wrapper").removeClass("col-xs-12");
      $(".html-wrapper").addClass("col-xs-6");
      $(".text-wrapper").removeClass("col-xs-12");
      return $(".text-wrapper").addClass("col-xs-6");
    };

    moo.prototype.auth = function(user, passwd) {
      this.ready();
      return this.socket.emit('io_line', 'CO ' + user + ' ' + passwd);
    };

    moo.prototype.close = function() {
      return this.socket.emit('close');
    };

    moo.prototype.telnet_line_in = function(line) {
      console.log('recvd a line');
      return App.Views.text_handler.insert(line);
    };

    moo.prototype.telnet_line_out = function(line) {
      return this.socket.emit('io_line', line);
    };

    moo.prototype.handle_markup = function(html) {
      return App.Views.html_handler.insert_markup(html);
    };

    moo.prototype.request_markup = function(ident) {
      console.log('requesting markup: ' + ident);
      return this.socket.emit('req_markup', ident);
    };

    return moo;

  })(Backbone.View);
});
