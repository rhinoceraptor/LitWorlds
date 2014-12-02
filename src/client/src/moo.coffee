# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.

define ["modals/disconnect_modal", \
"modals/error_modal", \
"modals/login_modal", \
"modals/settings_modal"],
(disconnect_modal, \
error_modal, \
login_modal, \
settings_modal) -> \
  class moo extends Backbone.View
    el: ".main-body"

    initialize: ->
      @socket = io.connect("http://127.0.0.1:8080" || location.host)
      @socket.on 'connect', () -> console.log 'connected to socket'
      @socket.on 'disconnect', @disconnect
      @socket.on 'error', @error
      @socket.on 'tcp_line', @telnet_line_in
      @socket.on 'markup', @handle_markup

    render: ->
      console.log 'rendering!'

    disconnect: ->
      new disconnect_modal().render()

    error: (e)->
      new error_modal().render(e)

    ready: ->
      @socket.emit('ready')

    reconnect: ->
      @connect.hide()

    # Set .text-wrapper to display: inline, .html-wrapper to display: none
    # Set the appropriate bootstrap class to .text-wrapper
    text_mode: ->
      console.log 'text_mode'
      $text = $(".text-wrapper")
      $text.css "display": "inline"
      $text.removeClass("col-xs-6")
      $text.addClass("col-xs-12")
      $(".html-wrapper").css "display": "none"
      $(".html-nav-bar").css "display": "none"
      $(".html-wrapper").removeClass("col-xs-6")
      $(".html-wrapper").removeClass("col-xs-12")

    # Set .html-wrapper to display: inline, .text-wrapper to display: none
    # Set the appropriate bootstrap class to .html-wrapper
    graphic_mode: ->
      console.log 'graphic_mode'
      $(".html-wrapper").css "display": "inline"
      $(".html-nav-bar").css "display": "block"
      $(".html-wrapper").removeClass("col-xs-6")
      $(".html-wrapper").addClass("col-xs-12")
      $(".text-wrapper").css "display": "none"
      $(".text-wrapper").removeClass("col-xs-6")
      $(".text-wrapper").removeClass("col-xs-12")

    # Set both .text-wrapper and .html-wrapper to display: inline
    #
    mixed_mode: ->
      console.log 'mixed_mode'
      $(".html-wrapper").css "display": "inline"
      $(".text-wrapper").css "display": "inline"
      $(".html-nav-bar").css "display": "block"
      $(".html-wrapper").removeClass("col-xs-12")
      $(".html-wrapper").addClass("col-xs-6")
      $(".text-wrapper").removeClass("col-xs-12")
      $(".text-wrapper").addClass("col-xs-6")

    auth: (user, passwd) =>
      @ready()
      # In the future, we could use a db to store user settings and that sort
      # of thing. For now, we'll just manually write 'CO user passwd' as normal.
      @socket.emit('io_line', 'CO ' + user + ' ' + passwd)

    close: () =>
      @socket.emit('close')

    telnet_line_in: (line) =>
      console.log 'recvd a line'
      App.Views.text_handler.insert(line)

    telnet_line_out: (line) =>
      @socket.emit('io_line', line)

    handle_markup: (html) =>
      App.Views.html_handler.insert_markup(html)

    request_markup: (ident) =>
      console.log 'requesting markup: ' + ident
      @socket.emit('req_markup', ident)
