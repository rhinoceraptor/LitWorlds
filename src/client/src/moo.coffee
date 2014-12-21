# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.

$ ->
  sock_port = '8080'
  app = {}
  app.text = new text_handler()

  # If params are undefined, set them for local testing
  if !params?
    moo_name = "Moo.js"
    host_name = "127.0.0.1"
    autologin = ""
    port = "7777"
    font = "Courier New"
    fontsize = "12"
    localecho = "false"
  # params should be a global variable in inline Javascript written by enCore
  else
    moo_name = params.MOOname
    host_name = params.HostName
    sock_server = params.SocketServer
    autologin = params.autologin
    port = params.port
    font = params.font
    fontsize = params.fontsize
    localecho = params.localecho

  # Create the socket variable and register event callbacks for it
  socket = io.connect('http://' + sock_server + ":" + sock_port)
  socket.on 'connect', () =>
    console.log 'connected to socket'
    # Emit the init event with the connection parameters for telnet.
    console.log 'initiate telnet connection to ' + host_name + ":" + port
    socket.emit('init', {server: host_name, port: port})

  socket.on('disconnect', () -> app.text.disconnect)
  socket.on('error', () -> app.text.error)
  socket.on('tcp_line', (telnet_data) => app.text.insert(telnet_data))

  $(window).resize () => set_height()
  set_height()


  # Use our autologin string for the telnet session if we have one
  if autologin?
    telnet_line_out(autologin + "\r\n")

set_height = () ->
  if top.frames["java_frame"]?
    frame_height = top.frames["java_frame"].innerHeight
    $("#text-mode-backlog").css "height": "#{frame_height - 35}px"
  else
    $("#text-mode-backlog").css "height": "300px"

telnet_line_out = (line) ->
  console.log 'emitting ' + line
  socket.emit('io_line', line)
