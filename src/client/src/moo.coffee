# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.
define [], () ->
  class moo extends Backbone.View
    el: ".main-body"

    initialize: ->
      @socket = io.connect(server + ":8080")
      @socket.on 'connect', () -> console.log 'connected to socket'
      @socket.on 'disconnect', @disconnect
      @socket.on 'error', @error
      @socket.on 'tcp_line', @telnet_line_in
      $(window).resize(() =>
        @set_height()
      )

    # Set the height correctly. autologin will an inline var in the source HTML
    render: () ->
      @set_height()
      @socket.emit('init', autologin)

    set_height: () ->
      frame_height = top.frames["java_frame"].innerHeight
      $("#text-mode-backlog").css
        "height": "#{frame_height - 35}px"
    disconnect: ->
      App.Views.text_handler.disconnect()

    error: ()->
      App.Views.text_handler.error()

    telnet_line_in: (line) =>
      App.Views.text_handler.insert(line)

    telnet_line_out: (line) =>
      @socket.emit('io_line', line)
