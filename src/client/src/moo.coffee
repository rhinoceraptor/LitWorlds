# moo.coffee contains the socket.io connection logic as well as some window
# resize CSS logic. It instantiates a text_handler and registers socket events.

# Use jQuery DOMReady function to ensure everything is loaded before
# instantiating app.text, registering resize callback, calling set_height
$ ->
  app.text = new text_handler()
  # iOS fires the $(window).resize() event on page scroll, don't register a
  # $(window).resize() event if we're on an iOS device. Call set_height once.
  device = navigator.platform
  if device isnt 'iPad' and device isnt 'iPhone' and device isnt 'iPod'
    $(window).resize(() -> set_height())
  set_height()

app = {}
sock_port = '8080'

# Set the height for text-backlog appropriately if we are in a frameset
set_height = () ->
  if top.frames["java_frame"]?
    frame_height = top.frames["java_frame"].innerHeight
    $("#text-backlog").css "height": "#{frame_height - 35}px"

telnet_line_out = (line) => socket.emit('io_line', line)

# If params are undefined, set them for local testing
if !params?
  moo_name = "Moo.js"
  host_name = "127.0.0.1"
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
console.log 'connecting to http://' + sock_server + ':' + sock_port
socket = io.connect('http://' + sock_server + ":" + sock_port)
socket.on 'connect', () =>
  console.log 'connected to socket'
  # Emit the init event with the connection parameters for telnet.
  console.log 'initiate telnet connection to ' + host_name + ":" + port
  socket.emit('init', {server: host_name, port: port})

socket.on('disconnect', () -> app.text.disconnect())
socket.on('err', () -> app.text.error())
socket.on('tcp_line', (telnet_data) => app.text.insert(telnet_data))

# Use our autologin string for the telnet session if we have one
if autologin?
  @telnet_line_out(autologin + "\r\n")
