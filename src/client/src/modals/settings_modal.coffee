define ->
  class @settings_modal extends Backbone.View
    el: "#settings-modal"
    events:
      "click #btn-cancel": "cancel"
      "click #btn-ok": "apply"

    initialize: (opts) =>
      @$okBtn = @$el.find("#btn-ok")

      $(document).on("keyup checkout", (e) =>
        if e.keyCode is 13
          e.preventDefault()
          @apply()
        if e.keyCode is 27
          e.preventDefault()
          @cancel())

    render: ->
      @$el.modal("show")
      this

    apply: (e) =>
      console.log 'ok:' + e
      # set previous line buffer length
      length = parseInt(@$el.find(".line-buf")[0].value)
      if length isnt null
        App.Views.text_handler.set_line_buffer(length)

      # set font face and size
      font = $(".font-select")[0].value
      font_size = $(".font-size").val()
      console.log font + ":" + font_size
      $(".text-mode-ul").css
        "font-family": font
        "font-size": font_size

      @cleanup()

    cancel: () =>
      @cleanup()

    # Remove backbone event handlers from el and hide the modal
    cleanup: () =>
      $(document).off("keyup checkout")
      @$el.off("click", "#btn-cancel")
      @$el.off("click", "#btn-ok")
      @$el.modal("hide")
