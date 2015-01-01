# io_line event tester for server.coffee
# Use it with jasmine-node:
# # npm install -g jasmine-node
# $ jasmine-node --coffee --forceexit spec/

net = require('net')
io = require('socket.io-client')

describe 'server.coffee', ->

  # socket.io text data comes in ArrayBuffer format, convert to UTF-8
  arraybuf_to_string = (buf) ->
    return String.fromCharCode.apply(null, new Uint8Array(buf))

  it 'should shuttle socket.io data to telnet', (done) ->
    telnet = net.createServer((srv) ->
      srv.on('data', (data) ->
        expect(arraybuf_to_string(data)).toEqual('hello from socket.io\r\n')
        done()
      )
    )
    telnet.listen(7779)

    socket = io.connect('http://127.0.0.1:8080')
    socket.emit('init', {server: '127.0.0.1', port: '7779'})
    socket.emit('io_line', 'hello from socket.io')