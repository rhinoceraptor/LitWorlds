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
###############################################################################

# Read config.json
config = fs.readFileSync('./config.json')
try
  obj = JSON.parse(config)
  server_name = obj.server_name
  socket_port = obj.socket_port
  telnet_server = obj.telnet_server
  enCore_base_URL = obj.enCore_URL
catch err
  console.log 'Error reading config.json!'
  process.exit(1)



# Networking variables
###############################################################################
telnet_port = 7777
telnet_host = 'literaryworlds.me'
socket_port = 8080
###############################################################################

# Set up express to serve the client and socket.io to listen to the socket_port
###############################################################################
app = express()
io = socket_io.listen(socket_port)
app.use('/', express.static('../client/'))

###############################################################################
# Main data interchange logic.
# The data is lines between the client and the telnet server.
# When a line of data comes from the telnet server, send it to the client.
# When a line of data comes from the socket.io client, sent it out on telnet.
###############################################################################
io.sockets.on('connection', (io) =>
  process.stdout.write('Incoming socket.io connection\n')
  io.on('auth', (authData) ->
    user = authData.user
    passwd = authData.passwd
  )
  io.on('ready', () ->
    process.stdout.write('connection is ready')
    telnet = net.createConnection(telnet_port, telnet_host)
    if user? and passwd? and telnet?
      if telnet.writable
        telnet.write('CO ' + user + '\n')
        telnet.write(passwd + '\n')
        io.emit('authenticated')

    telnet.on('data', (telnetData) ->
      process.stdout.write('Recieved from server: ' + telnetData + '\n')
      process.stdout.write('emitting to client\n')
      io.emit('tcp_line', telnetData)
    ).on('error', () ->
      io.emit('error')
    ).on('close', () ->
      io.emit('disconnect')
    )

    io.on('io_line', (socketData) ->
      process.stdout.write('Recieved from client:\n>>>' + socketData + '\n')
      if telnet?
        if telnet.writable
          telnet.write(socketData + "\n")
        else
          io.emit('error', 'timeout')
    ).on('error', () ->
      process.stdout.write('Error writing to telnet!')
    )

    io.on('disconnect', () ->
      process.stdout.write('disconnect the telnet connection!\n')
      if telnet?
        telnet.destroy()
        telnet = null
    )

    io.on('close', () ->
      process.stdout.write('close the telnet connection!\n')
      if telnet?
        telnet.destroy()
        telnet = null
    )

  )

)

app.listen(80, (err) ->
  return cb(err)  if err

  # Find out which user used sudo through the environment variable
  uid = parseInt(process.env.SUDO_UID)

  # Set our server's uid to that user
  process.setuid uid  if uid
  console.log "Server's UID is now " + process.getuid()
)
