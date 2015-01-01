# Literary Worlds
# Node.JS interchange server
# Interchanges data between a client with socket.io and a MUD server

# Dependancy imports
####################
net = require('net')
socket_io = require('socket.io')
socket_port = '8080'

# Create the io var, and listen for client connections
io = socket_io.listen(socket_port)

# Listen for client connections
io.sockets.on('connection', (io) ->
  console.log('Incoming socket.io connection\n')
  # When the client sends init event, call handle_session
  io.on('init', (param) => handle_session(io, param))
)

# Handle a user session. When telnet data comes in, write it to the user over
# websocket. When user sends data over the websocket, send it to telnet session.
# param is a JSON object with the server and port to connect to over telnet.
handle_session = (io, param) =>
  telnet_server = param.server
  telnet_port = param.port

  # Create the telnet session
  telnet = net.createConnection(telnet_port, telnet_server)
  console.log 'created telnet connection via ' + telnet_server + ":" + telnet_port

  # Register telnet events
  telnet.on('data', (telnet_data) -> io.emit('tcp_line', telnet_data))
  telnet.on('error', () -> io.emit('err'))
  telnet.on('close', () -> io.emit('disconnect'))

  # Register socket.io events
  io.on('io_line', (socket_data) -> io_line(telnet, io, socket_data))
  io.on('error', () -> io.emit('err', 'timeout'))
  io.on('disconnect', () -> close_telnet(telnet))
  io.on('close', () -> close_telnet(telnet))

# When the client sends data over the socket.io connection, write it to telnet
io_line = (telnet, io, socket_data) =>
  if telnet? and telnet.writable
    telnet.write(socket_data + "\r\n")
  else
    io.emit('err')

# Close the telnet connection, and set the telnet var to null
close_telnet = (telnet) =>
  console.log('close the telnet connection!\n')
  if telnet?
    telnet.destroy()
    telnet = null
