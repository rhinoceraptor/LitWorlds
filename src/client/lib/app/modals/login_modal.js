// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(function() {
  return this.login_modal = (function(_super) {
    __extends(login_modal, _super);

    function login_modal() {
      this.cleanup = __bind(this.cleanup, this);
      this.cancel = __bind(this.cancel, this);
      this.guest = __bind(this.guest, this);
      this.ok = __bind(this.ok, this);
      return login_modal.__super__.constructor.apply(this, arguments);
    }

    login_modal.prototype.el = "#login-modal";

    login_modal.prototype.events = {
      "click #btn-cancel": "cancel",
      "click #btn-ok": "ok",
      "click #btn-guest": "guest"
    };

    login_modal.prototype.initialize = function(opts) {
      this.$okBtn = this.$el.find("#btn-ok");
      this.$user = this.$el.find(".login-user");
      this.$passwd = this.$el.find(".login-passwd");
      $(document).on("keyup checkout", (function(_this) {
        return function(e) {
          if (e.keyCode === 13) {
            e.preventDefault();
            _this.ok();
          }
          if (e.keyCode === 27) {
            e.preventDefault();
            return _this.cancel();
          }
        };
      })(this));
      this.$user.val("");
      this.$passwd.val("");
      return this.$el.on("shown.bs.modal", (function(_this) {
        return function() {
          return _this.$user.focus();
        };
      })(this));
    };

    login_modal.prototype.render = function() {
      this.$el.modal("show");
      return this;
    };

    login_modal.prototype.ok = function(e) {
      console.log('login ok');
      if (this.$el.find(".login-user").val() === "" || this.$el.find(".login-passwd").val() === "") {
        this.wiggle();
      } else {
        App.Views.mainView.auth(this.$user.val(), this.$passwd.val());
        return this.cleanup();
      }
    };

    login_modal.prototype.guest = function() {
      App.Views.mainView.auth("guest", "");
      return this.cleanup();
    };

    login_modal.prototype.cancel = function() {
      return this.cleanup();
    };

    login_modal.prototype.wiggle = function() {
      var i, len, _results;
      len = 20;
      i = 0;
      _results = [];
      while (i < 4) {
        this.$el.animate({
          'margin-left': "+=" + (len = -len) + 'px'
        }, 50);
        _results.push(i++);
      }
      return _results;
    };

    login_modal.prototype.cleanup = function() {
      $(document).off("keyup checkout");
      this.$el.off("click", "#btn-cancel");
      this.$el.off("click", "#btn-ok");
      this.$el.off("click", "#btn-guest");
      return this.$el.modal("hide");
    };

    return login_modal;

  })(Backbone.View);
});
