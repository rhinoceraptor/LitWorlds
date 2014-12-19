# Literary Worlds
# Node.JS interchange server
# Interchanges data between a client with socket.io and a LambdaMOO server

# Dependancy imports
###############################################################################
net = require 'net'
socket_io = require 'socket.io'
port = "8080" # leave this in config!

io = socket_io.listen(port)

# Listen for client connections
io.sockets.on('connection', (io) =>
  console.log('Incoming socket.io connection\n')
  # When the client sends init event with autologin string, call handle_session
  io.on('init', (autologin) => handle_session(io, autologin))
)

# Handle a user session. When telnet data comes in, write it to the user over
# websocket. When user sends data over the websocket, send it to telnet session
handle_session = (io, autologin) =>
  # Create the telnet session
  telnet = net.createConnection(telnet_port, server)

  if autologin isnt "" and autologin isnt null
    # Use our autologin string for the telnet session if it's not null
    telnet.write(autologin + "\r\n")

  telnet.on('data', (telnetData) ->
    io.emit('tcp_line', telnetData)
  ).on('error', () ->
    io.emit('error')
  ).on('close', () ->
    io.emit('disconnect')
  )

  io.on('io_line', (socketData) ->
    if telnet?
      if telnet.writable
        telnet.write(socketData + "\r\n")
      else
        io.emit('error', 'timeout')
  ).on('error', () ->
    io.emit('error', 'timeout')
    console.log('Error writing to telnet!')
  )

  io.on('disconnect', () ->
    console.log('disconnect the telnet connection!\n')
    if telnet?
      telnet.destroy()
      telnet = null
  )

  io.on('close', () ->
    console.log('close the telnet connection!\n')
    if telnet?
      telnet.destroy()
      telnet = null
  )
