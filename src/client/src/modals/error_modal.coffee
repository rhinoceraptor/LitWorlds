###############################################################################
# error modal dialog
# When the TCP connection on the server side has an issue, this modal dialog
# will alert the user to this fact.
###############################################################################

define ->
  class @error_modal extends Backbone.View
    el: "#error-modal"
    events:
      "click #btn-ok": "ok"

    initialize: (opts) ->
      @$okBtn = @$el.find("#btn-ok")

      $(document).on("keyup checkout", (e) =>
        if e.keyCode is 13
          e.preventDefault()
          @ok()
        if e.keyCode is 27
          e.preventDefault()
          @cancel())

    render: (e) =>
      @$el.modal()
      @handle_err_msg(e)
      this

    handle_err_msg: (e) =>
      # Default error message
      err_msg = "Something has gone wrong, the server could not make a " + \
        " connection to the Literary Worlds MUD.\nPlease try again later."
      # Handle timeout event
      if e is "timeout"
        err_msg = "The Literary Worlds MUD connection timed out.\n" + \
          "Please reconnect to continue.\n You can do this by " + \
          "pressing Login and entering your account details, or by " + \
          "pressing Connect and logging in manually."
      # Send the error message to the text backlog as well as the modal's text
      console.log App.Views
      App.Views.text_handler.clear_backlog()
      App.Views.text_handler.insert(err_msg)
      $(".error-msg")[0].innerText = err_msg

    ok: () =>
      @cleanup()

    cleanup: () ->
      $(document).off("keyup checkout")
      @$el.off("click", "#btn-ok")
      @$el.modal("hide")
