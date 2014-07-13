io = require 'socket.io'
http = require 'http'
fs = require 'fs'
net = require 'net'

config = require './config'

server = http.createServer((req, res) ->
	path = req.url
	switch path
		when '/'
			console.log 'connection!'
			fileName = __dirname + '/index.html'
			fs.readFile fileName, (err, text) ->
				if err
					console.log err
					res.writeHead(404)
					res.write 'An error occured, try again later?'
					res.end()
				else
					console.log 'writing web page ' +  __dirname + '/index.html'
					res.writeHead 200, {'Content-Type' : 'text/html'}
					res.write(text)
					res.end()
		else
			res.writeHead 404
			res.write 'An error occured, try again later?'
			res.end()

	res.end()
	console.log 'connection closed'
)


console.log 'Starting web server at ' + config.webServer.url + ':' + config.webServer.port
server.listen(config.webServer.port, config.webServer.url)