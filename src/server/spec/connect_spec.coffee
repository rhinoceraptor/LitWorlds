# simple tester for server.coffee
# Use it with jasmine-node:
# # npm install -g jasmine-node
# $ jasmine-node --coffee --forceexit spec/server_spec.coffee

net = require('net')
io = require('socket.io-client')

describe 'server.coffee', ->
  # Create a socket.io connection and a telnet server to connect back to
  socket = io.connect('http://127.0.0.1:8080')

  it 'should accept socket.io connections on port 8080', (done) ->
    socket.on('connect', () ->
      expect(socket.connected).toEqual(true)
      done()
    )

  it 'should make a telnet connection given init event', (done) ->
    telnet = net.createServer(() ->
      telnet.getConnections((err, count) ->
        expect(count).toEqual(1)
        done()
      )
    )
    telnet.listen(7777)

    # Prompt the server to connect to back via telnet
    socket.emit('init', {server: '127.0.0.1', port: '7777'})

