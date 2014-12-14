# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.

define [], () ->
  class moo extends Backbone.View
    el: ".main-body"

    initialize: ->
      @socket = io.connect("http://127.0.0.1:8080" || location.host)
      @socket.on 'connect', () -> console.log 'connected to socket'
      @socket.on 'disconnect', @disconnect
      @socket.on 'error', @error
      @socket.on 'tcp_line', @telnet_line_in

    # Here, we recieve the hash URL parameter, which is the autoloign string
    # for enCore. We send it over the socket, which prompts the server to
    # connect to telnet for us, and it sends the autologin string.
    render: (autologin) ->
      @socket.emit('init', autologin)

    disconnect: ->
      App.Views.text_handler.disconnect()

    error: ()->
      App.Views.text_handler.error()

    telnet_line_in: (line) =>
      App.Views.text_handler.insert(line)

    telnet_line_out: (line) =>
      @socket.emit('io_line', line)
