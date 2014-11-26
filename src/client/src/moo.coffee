###############################################################################
# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.
###############################################################################


define ["modals/disconnect_modal", \
"modals/error_modal", \
"modals/login_modal", \
"modals/settings_modal"],
(disconnect_modal,\
error_modal,\
login_modal,\
settings_modal) -> \
  class moo extends Backbone.View
    el: ".main-body"

    initialize: ->
      console.log 'moo'

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

    text_mode: ->
      console.log 'text_mode'

    graphic_mode: ->
      console.log 'graphic_mode'

    mixed_mode: ->
      console.log 'mixed_mode'

    auth: (user, passwd) =>
      @ready()
      # In the future, we could use a db to store user settings and that sort
      # of thing. For now, we'll just manually write 'CO user passwd' as normal.
      #@socket.emit('auth', {'user' : user, 'passwd': passwd})
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
      @socket.emit('req_markup', ident)
