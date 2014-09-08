net = require 'net'
http = require 'http'
io = require 'socket.io'

telnetPort = 7777
telnetHost = 'brn227.brown.wmich.edu'

socketPort = 8080

console.log('Starting socket server on port ' + socketPort)
io = io.listen(socketPort)

# Main data interchange logic.
# The data is lines between the client and the telnet server.
# When a line of data comes from the telnet server, send it to the client.
# When a line of data comes from the socket.io client, sent it to the telnet server.
# Todo: investigate client authentication, security precautions
io.sockets.on('connection', (ioSocket) ->
	process.stdout.write('Incoming socket.io connection\n')
	ioSocket.emit('telnetLine', 'Hello from socket.io')
	ioSocket.on('auth', (authData) ->
		user = authData.user
		passwd = authData.passwd
	)

	telnet = net.createConnection(telnetPort, telnetHost)
	telnet.on('data', (telnetData) ->
		process.stdout.write('Recieved from server: ' + telnetData + '\n')
		ioSocket.emit('telnetLine' + telnetData)
	).on('connect', () ->
		telnet.write('CO ' + user + '\n' + passwd)
		ioSocket.emit('authenticated')
	).on('end', () ->
		ioSocket.emit('disconnected')
	)
	
	ioSocket.on('client_line', (socketData) ->
		process.stdout.write('Recieved from client:\n>>>\t' + socketData + '\n')
		telnet.write(socketData)
	)

	ioSocket.on('disconnect', () ->
		process.stdout.write('disconnect the telnet connection!\n')
		telnet.end()
	)

)
