net = require 'net'
http = require 'http'
io = require 'socket.io'

telnet_port = 7777
telnet_host = '104.131.36.137'

socket_ort = 8080

console.log('Starting socket server on port ' + socket_ort)
io = io.listen(socket_ort)

telnet_connected = false

# Main data interchange logic.
# The data is lines between the client and the telnet server.
# When a line of data comes from the telnet server, send it to the client.
# When a line of data comes from the socket.io client, sent it to the telnet server.
# Todo: investigate client authentication, security precautions
io.sockets.on('connection', (socket) ->
	process.stdout.write('Incoming socket.io connection\n')
	socket.emit('telnet_line', 'Hello from socket.io')
	socket.on('auth', (authData) ->
		user = authData.user
		passwd = authData.passwd

		if telnet?
			telnet.write('CO ' + user + '\n' + passwd)
			socket.emit('authenticated')
	
		try
			telnet = net.createConnection(telnet_port, telnet_host)
			telnet.on('data', (telnet_data) ->
				process.stdout.write('Recieved from server: ' + telnet_data + '\n')
				process.stdout.write('emitting to client\n')
				socket.emit('telnet_line', telnet_data)
			).on('end', () ->
				socket.emit('disconnected')
			)
		catch(ex)
			socket.emit('telnet_error', ex)

		try
			socket.on('client_line', (socket_data) ->
				process.stdout.write('Recieved from client:\n>>>' + socket_data + '\n')
				telnet.write(socket_data + "\n")
			)
		catch(ex)
			socket.emit('telnet_error', ex)

		socket.on('disconnect', () ->
			process.stdout.write('disconnect the telnet connection!\n')
			telnet.end()
		)
	)
)