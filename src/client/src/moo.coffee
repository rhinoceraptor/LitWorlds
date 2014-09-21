###############################################################################
# Central class for the Literate Worlds project.
# moo.coffee handles all of the socket.io logic, other classes call functions
# here when they need to do something with the socket.
###############################################################################


define ["modals/disconnect_modal", \
"modals/login_modal", \
"modals/settings_modal", \
"text_handler"],
(disconnect_modal,
login_modal,
settings_modal,
text_handler) ->
class @moo extends Backbone.View
	el: ".main-body"

	initialize: ->
		console.log 'moo'
		@text_handler = new text_handler

		@socket = io.connect('http://127.0.0.1:8080' || location.host)
		@socket.on 'connect', () -> console.log 'connected to socket'
		@socket.on 'disconnect', @disconnect
		@socket.on 'telnetLine', @telnet_line_in

	render: ->
		console.log 'rendering!'

	auth: (user, passwd) =>
		@socket.emit('auth', {'user': user, 'passwd': passwd})

	disconnect: ->
		new disconnect_modal().render()

	reconnect: ->
		@connect.hide()

	text_mode: ->
		console.log 'text_mode'

	graphic_mode: ->
		console.log 'graphic_mode'

	mixed_mode: ->
		console.log 'mixed_mode'

	telnet_line_in: (line) =>
		@text_handler.insert(line)

	telnet_line_out: (line) =>
		@socket.emit('client_line', line)
