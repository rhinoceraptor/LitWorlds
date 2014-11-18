define ->
  class @license_modal extends Backbone.View
    el: "#license-modal"
    events:
      "click #btn-ok": "ok"

    render: ->
      @$el.modal()
      this

    initialize: (opts) ->
      @$okBtn = @$el.find("#btn-ok")

      $(document).on("keyup checkout", (e) =>
        if e.keyCode is 13
          e.preventDefault()
          @ok()
        if e.keyCode is 27
          e.preventDefault()
          @cancel())

    ok: =>
      @cleanup()

    cleanup: ->
      @$el.off("click", "#btn-ok")
      @$el.modal("hide")
