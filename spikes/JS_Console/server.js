//Server.js
//---------

// This file contains the server infromation and setup.
//
// Parameters:
// var `http` contains the node http library
// var `fs` contains the node file system library
// var `io` contains the socket io library
// var `port` is the port number the server uses
// var `serverUrl` is the ip address of the server
// var `counter` counts the number of request made to the server
//
// var 'telnetServer' contains the domain name to telnet to
// var 'telnetPort' conatains 'telnetServer''s port
//

var http = require('http');
var fs = require('fs');
var io = require('socket.io');
var port = 3001;
var serverUrl = '127.0.0.1';
var counter = 0;

var telnetServer = 'brn227.brown.wmich.edu'
var telnetPort = '7777'

//
// var `server` is the created http server that uses the anonymous callback
// function to handle requests `req` and responses `res` made to and from the
// server.
//
var server = http.createServer(function(req, res) 
{
	// var `path` contains the requested url sent to the server
	var path = req.url;
	counter++;

	// Log the request to the to the console and increment `counter`
	console.log('Request: ' + path + ' (' + counter + ')');

	// This switch statment routes the request made to the server
	// each case handles one of the few request that can be made to the server
	switch (path) 
	{
		// "/" case handles the index page of the server
		case '/':
			res.writeHead(200, {'Content-Type' : 'text/html'});
			res.write('<p>Hello World. Request counter: ' + counter + '.</p>');
			break;

		// "/telnet.html" case reads the socket.html file and displays it in the browser
		case '/telnet.html':
			fs.readFile('telnet.html', function(err, text) 
			{
				if (err) 
				{
					res.writeHead(404);
					res.write('The internet broke! - 404');
					res.end();
				}
				else 
				{
					res.writeHead(200, {'Content-Type' : 'text/html'});
					res.write(text);
					res.end();
				}
			});
			return;
			break;

		// default case displays a 404 error as the page does not exsit
		default:
			res.writeHead(404);
			res.write('Uh oh! - 404');
			break;

	}

	// `res.end()` tell the server that the response ended and executes
	res.end();

});

// Print to the console that the server is starting
console.log('Starting web server at ' + serverUrl + ':' + port);

// Start listening over the passed port `port` and url `serverUrl`
server.listen(port, serverUrl);

// var `ser_io` contains socket io server side listener
var ser_io = io.listen(server);
ser_io.set('log level', 1);

// Socket IO sends the date and time to the client and updates every second
ser_io.sockets.on('connection', function(socket) 
{
	setInterval(function() 
	{
		socket.emit('date', {'date': new Date()});
	}, 1000);

	// Socket IO recieves the information typed into the client and sends to the server
	socket.on('client_data', function(data) 
	{
		process.stdout.write(data.msg);
		if (data.msg === 'ping\n')
		{
			socket.emit('server_data', {'msg': "pong"});
			console.log("emitting pong");
		}
	});
});
