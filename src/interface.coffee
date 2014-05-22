(($) ->
	console.log('ready!!!!!')
	enterButton: ->
		console.log('enterButton')
		# Prevent newlines from being made in text input
		@preventDefault

		# Variables for entry and stack text areas
		entryBox = $("#entry")
		stackBox = $("#stack")

		# Append to stack, then erase entry
		# If there is no text already, don't add a newline.
		if stackBox.val?
			stackBox.val(stackBox.val() + '\n' + entryBox.val())
		else
			stackBox.val(stackBox.val() + entryBox.val())
		# Erase entry
		entryBox.val('')

		# Automatically scroll the output
		stackBox.scrollTop(stackBox[0].scrollHeight - stackBox.height())

	num: (param) ->


	add: ->

	sub: ->

	mult: ->

	div: ->


  
) jQuery