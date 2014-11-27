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
scrape = require './scrape'

# Read config.json, set parameters accordingly
###############################################################################
config = fs.readFileSync('./config.json')
try
  obj = JSON.parse(config)
  server_name = obj.server_name
  socket_port = obj.socket_port
  node_domain = obj.node_domain
  telnet_server = obj.telnet_server
  telnet_port = obj.telnet_port
  enCore_port = obj.enCore_port
  enCore_init = obj.enCore_init
  console.log 'server configuration:\n---------------------'
  console.log '\tserver_name: ' + server_name
  console.log '\tsocket_port: ' + socket_port
  console.log '\tnode_domain: ' + node_domain
  console.log '\ttelnet_server: ' + telnet_server
  console.log '\ttelnet_port: ' + telnet_port
  console.log '\tenCore_port: ' + enCore_port
  console.log '\tenCore_init: ' + enCore_init
catch err
  console.log 'Error reading config.json!'
  process.exit(1)

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
  console.log('Incoming socket.io connection\n')
  io.on('auth', (authData) ->
    user = authData.user
    passwd = authData.passwd
  )

  io.on('ready', () ->
    console.log('connection is ready')
    telnet = net.createConnection(telnet_port, telnet_server)
    s = new scrape(telnet_server, enCore_port, node_domain)

    # Initial landing page is 62
    s.get_html(enCore_init, (html) =>
      console.log 'sending html to client'
      io.emit('markup', html)
    )

    if user? and passwd? and telnet?
      if telnet.writable
        telnet.write('CO ' + user + '\n')
        telnet.write(passwd + '\n')
        io.emit('authenticated')

    telnet.on('data', (telnetData) ->
      console.log('Recieved from server: ' + telnetData + '\n')
      console.log('emitting to client\n')
      io.emit('tcp_line', telnetData)
    ).on('error', () ->
      io.emit('error')
    ).on('close', () ->
      io.emit('disconnect')
    )

    io.on('io_line', (socketData) ->
      console.log('Recieved from client:\n>>>' + socketData + '\n')
      if telnet?
        if telnet.writable
          telnet.write(socketData + "\n")
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

    io.on('req_markup', (ident) =>
      # ident is the identifer for the encore URL to return
      s.get_html(ident, (html) =>
        console.log 'sending html to client'
        io.emit('markup', html)
      )
    )
  )
)

app.listen(80, (err) ->
  return cb(err) if err
  # Find out which user used sudo through the environment variable
  uid = parseInt(process.env.SUDO_UID)
  # Set our server's uid to that user
  process.setuid uid if uid
  console.log "Server's UID is now " + process.getuid()
)
