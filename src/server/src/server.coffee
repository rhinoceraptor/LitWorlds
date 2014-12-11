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
auth_cookie = require './auth_cookie'

# Read config.json, set parameters accordingly
###############################################################################
config = fs.readFileSync('./config.json')
try
  obj = JSON.parse(config)
  server_name = obj.server_name
  socket_port = obj.socket_port
  node_domain = obj.node_domain
  server = obj.server
  telnet_port = obj.telnet_port
  enCore_port = obj.enCore_port
  enCore_init = obj.enCore_init
  console.log 'server configuration:\n---------------------'
  console.log '\tserver_name: ' + server_name
  console.log '\tsocket_port: ' + socket_port
  console.log '\tnode_domain: ' + node_domain
  console.log '\tserver: ' + server
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

# Handle a user session. When telnet data comes in, write it to the user over
# the websocket. When the user sends data over the websocket, send it out on
# telnet. When the telnet connection sends an URL, scrape the HTML and send it
# to the client.

# When a user connects, and then fires the auth event, call get_auth
io.sockets.on('connection', (io) =>
  console.log('Incoming socket.io connection\n')
  # On auth event, kick off getting access code and autologin string
  io.on('auth', (authData) => get_auth(io, authData))
)

# Get the client authenticated, we need an autologin string for telnet and an
# access code cookie to present to enCore when making requests of it.
get_auth = (io, authData) =>
  # Get an access code cookie from enCore
  console.log 'auth ' + authData.user + ":" + authData.passwd
  auth = new auth_cookie(server, enCore_port)

  # Using that access code, get an autologin string for our user and password
  auth.get_access_code(authData.user, authData.passwd, (access_code) =>
    console.log 'access code is ' + access_code
    if access_code is "failed"
      io.emit("auth_fail")
    else
      auth.get_autologin_string(access_code, (autologin) =>
        console.log 'autologin is ' + autologin
        handle_session(io, access_code, autologin)
      )
  )

# We have access code and autologin string, now handle telnet and HTTP events
handle_session = (io, access_code, autologin) =>
  telnet = net.createConnection(telnet_port, server)
  s = new scrape(server, enCore_port, node_domain)

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

  # Used when the client requested an identifer based on the hash URLs
  io.on('req_markup', (ident) =>
    console.log 'client requested hash URL ' + ident
    # ident is the identifer for the encore URL to return
    url = "http://" + server + ":" + enCore_port + "/" + ident
    s.get_html(url, access_code, (html) =>
      console.log 'sending ' + url + ' html to client'
      io.emit('markup', html)
    )
  )

  # Used when the client requests a URL based on what comes over telnet
  io.on('req_url', (url) =>
    console.log 'client requested page ' + url
    s.get_html(url, access_code, (html) =>
      console.log 'sending ' + url + ' html to client'
      io.emit('markup', html)
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
