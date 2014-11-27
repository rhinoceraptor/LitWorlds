// Generated by CoffeeScript 1.7.1
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(["moo"], function(moo) {
  var moo_router;
  return moo_router = (function(_super) {
    __extends(moo_router, _super);

    function moo_router() {
      return moo_router.__super__.constructor.apply(this, arguments);
    }

    moo_router.prototype.routes = {
      "": "moo",
      "text": "text_mode",
      "mixed": "mixed_mode",
      "graphic": "graphic_mode",
      "login": "login",
      "settings": "settings",
      "encore": "encore",
      "*other": "moo"
    };

    moo_router.prototype.moo = function(param) {
      if (App.Views.mainView == null) {
        App.Views.mainView = new moo;
        App.Views.mainView.render();
      }
      if ((param != null) && param.indexOf("encore") > -1) {
        console.log(param.substring("encore/".length, param.length));
        console.log(parseInt(param.substring("encore/".length, param.length)));
      }
      if ((param != null) && param.indexOf("license") > -1) {
        return this.license();
      }
    };

    moo_router.prototype.text_mode = function() {
      this.moo();
      return App.Views.navbar.text_mode();
    };

    moo_router.prototype.mixed_mode = function() {
      this.moo();
      return App.Views.navbar.mixed_mode();
    };

    moo_router.prototype.graphic_mode = function() {
      this.moo();
      return App.Views.navbar.graphic_mode();
    };

    moo_router.prototype.license = function() {
      console.log("license");
      return App.Views.navbar.show_license_modal();
    };

    moo_router.prototype.login = function() {
      this.moo();
      console.log("login");
      return App.Views.navbar.show_login_modal();
    };

    moo_router.prototype.settings = function() {
      this.moo();
      console.log("settings");
      return App.Views.navbar.show_settings_modal();
    };

    return moo_router;

  })(Backbone.Router);
});
