# tcp_line event tester for server.coffee
# Use it with jasmine-node:
# # npm install -g jasmine-node
# $ jasmine-node --coffee --forceexit spec/

net = require('net')
io = require('socket.io-client')

describe 'server.coffee', ->
  # Create a socket.io connection and a telnet server to connect back to

  # socket.io text data comes in ArrayBuffer format, convert to UTF-8
  arraybuf_to_string = (buf) ->
    return String.fromCharCode.apply(null, new Uint8Array(buf))

  it 'should shuttle telnet data to socket.io', (done) ->
    telnet = net.createServer((srv) ->
      srv.write('hello world\r\n')
    )
    telnet.listen(7778)
    socket = io.connect('http://127.0.0.1:8080')

    socket.on('tcp_line', (data) ->
      expect(arraybuf_to_string(data)).toEqual('hello world\r\n')
      done()
    )

    socket.emit('init', {server: '127.0.0.1', port: '7778'})
