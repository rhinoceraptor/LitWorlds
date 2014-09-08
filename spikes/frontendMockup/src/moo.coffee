define ["modals/disconnect_modal", "text_handler"], 
	(disconnect_modal, text_handler) ->
	class moo extends Backbone.View
		el: ".main-body"

		initialize: ->
			@socket = io.connect('http://127.0.0.1:8080' || location.host)

			@socket.on 'connect', () -> console.log 'connected to socket'
			@socket.on 'disconnect', @disconnect()
			@socket.on 'telnetLine', @telnet_line(telnet_line)

		disconnect: ->
			connect = new disconnect_modal().render()

		reconnect: ->
			@connect.hide()

		text_mode: ->
			console.log 'text_mode'

		graphic_mode: ->
			console.log 'graphic_mode'

		mixed_mode: ->
			console.log 'mixed_mode'

		telnet_line: (line) ->
			App.Views.main.text_handler.insertLine(line)