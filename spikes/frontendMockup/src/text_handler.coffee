define ->
	class text_handler extends Backbone.View
		el: ".text-wrapper"
		initialize: ->
			console.log 'hello from text_handler'
			@$el.on "keyup", "#text-mode-input", @keyup_handler()

		events:
			"keyup #text-mode-input": "keyup_handler"
		insertLine: (line) ->
			$logOut = $("#text-mode-backlog")
			# Append to backlog, then erase console
			# If there is no text already, don't add a newline.
			if $logOut.val() isnt ''
				$logOut.val($logOut.val() + '\n' + line)
			else
				$logOut.val($logOut.val() + line)

		keyup_handler: (e) ->
			console.log e