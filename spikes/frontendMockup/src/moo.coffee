define ["modals/disconnectModal"], (disconnectModal) ->
	class moo extends Backbone.View
		el: ".main-body"

		initialize: ->
			console.log 'moooo!'

		disconnect: ->
			connect = new disconnectModal().render()

		reconnect: ->
			@connect.hide()

		textMode: ->
			console.log 'textMode'
		graphicMode: ->
			console.log 'graphicMode'
		mixedMode: ->
			console.log 'mixedMode'