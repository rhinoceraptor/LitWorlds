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
###############################################################################

# Networking variables
###############################################################################
telnet_port = 7777
telnet_host = '127.0.0.1'
socket_port = 8080
###############################################################################

# Set up express to serve the client and socket.io to listen to the socket_port
###############################################################################
app = express()
io = socket_io.listen(socket_port)
app.use('/', express.static('../client/'))

# Main data interchange logic.
# The data is lines between the client and the telnet server.
# When a line of data comes from the telnet server, send it to the client.
# When a line of data comes from the socket.io client, sent it to the telnet server.
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
# run sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/node
app.listen(80)
