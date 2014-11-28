// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function() {
  return this.html_handler = (function(_super) {
    __extends(html_handler, _super);

    function html_handler() {
      this.parse_links = __bind(this.parse_links, this);
      return html_handler.__super__.constructor.apply(this, arguments);
    }

    html_handler.prototype.el = ".html-container";

    html_handler.prototype.initialize = function() {
      this.link_idents = new Array();
      return this.link_text = new Array();
    };

    html_handler.prototype.link_handler = function(ident) {
      console.log('requesting ' + ident);
      App.Views.mainView.request_markup(ident);
      this.link_array = new Array();
      return this.link_idents = new Array();
    };

    html_handler.prototype.insert_markup = function(html) {
      return this.$el.html(html);
    };

    html_handler.prototype.parse_links = function(html) {
      return $(html).each('a').each(function(i, link) {
        var ident, text;
        ident = parseInt(link.substring("encore/".length, link.length));
        this.link_idents.push(ident);
        text = link.innerText;
        return this.link_text.push(text);
      });
    };

    html_handler.prototype.remove_markup = function() {
      return this.$el.empty();
    };

    return html_handler;

  })(Backbone.View);
});
