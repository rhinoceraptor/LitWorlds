# Literary Worlds
# Node.JS interchange server
# Interchanges data between a client with socket.io and a LambdaMOO server,
# over telnet.

# Dependancy imports
###############################################################################
net = require 'net'
http = require 'http'
socket_io = require 'socket.io'
express = require 'express'
http = require 'http'
fs = require 'fs'

# Read config.json, set parameters accordingly
###############################################################################
config = fs.readFileSync('./config.json')
try
  obj = JSON.parse(config)
  server_name = obj.server_name
  socket_port = obj.socket_port
  client_port = obj.client_port
  node_domain = obj.node_domain
  server = obj.server
  telnet_port = obj.telnet_port
  console.log 'server configuration:\n---------------------'
  console.log '\tserver_name: ' + server_name
  console.log '\tsocket_port: ' + socket_port
  console.log '\tclient_port: ' + client_port
  console.log '\tnode_domain: ' + node_domain
  console.log '\tserver: ' + server
  console.log '\ttelnet_port: ' + telnet_port
catch err
  console.log 'Error reading config.json!'
  process.exit(1)

# Set up express to serve the client and socket.io to listen to the socket_port
###############################################################################
app = express()
io = socket_io.listen(socket_port)
app.use('/', express.static('../client/'))

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

  # Use our autologin string for the telnet session
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

app.listen(client_port, (err) ->
  if err
    console.log err
)
