$ ->
	console.log('ready')
	container = {}
	container.rpnCalc = new rpnCalc()

	$("#enter").click ->
		# Variables for entry and stack text areas
		$entryBox = $("#entry")
		$stackBox = $("#stack")

		# Check if the entryBox has input and if it is a valid decimal number
		if $entryBox.val() and isNumber($entryBox.val())
			# push the entry to the rpnCalc stack
			console.log("pushing " + $entryBox.val())
			container.rpnCalc.push(parseInt($entryBox.val(), 10))

			# Append to stack box, then erase entry
			# If there is no text already, don't add a newline.
			if $stackBox.val() != ''
				$stackBox.val($stackBox.val() + '\n' + $entryBox.val())
			else
				$stackBox.val($entryBox.val())
			# Erase entry
			$entryBox.val('')
			# Automatically scroll the output
			$stackBox.scrollTop($stackBox[0].scrollHeight - $stackBox.height())

	$(".number").click ->
		$entryBox = $("#entry")
		oldEntry = $entryBox.val()
		$entryBox.val(oldEntry + @id)
		console.log(oldEntry + @id)

	$(".operator").click ->
		if container.rpnCalc.operationIsPossible()
			removeLines(2)
			switch @id.toString()
				when '+' 
					result = container.rpnCalc.add()
				when '-' 
					result = container.rpnCalc.sub()
				when '*' 
					result = container.rpnCalc.mult()
				when '/' 
					result = container.rpnCalc.div()
			placeInStackBox(result)

	$(".function").click ->
		if @id.toString() isnt 'clear' then removeLines(2)
		switch @id.toString()
			when 'clear'
				removeLines(container.rpnCalc.returnIndex())
				container.rpnCalc.clr()
			when 'exp'
				result = container.rpnCalc.exp()
			when 'mod'
				result = container.rpnCalc.mod()
			when 'sqrt'
				result = container.rpnCalc.sqrt()
		if @id.toString() isnt 'clear' and result isnt false then placeInStackBox(result)

	removeLines = (numLines) ->
		# remove last two lines from stackBox
		$stackBox = $("#stack")
		stackText = $stackBox.val().split('\n')
		numLines = parseInt(container.rpnCalc.returnIndex())
		console.log("removing lines " + numLines + " to " + numLines - numLines)
		stackText.splice(numLines - numLines, numLines)
		$stackBox.val(stackText.join('\n'))

	placeInStackBox = (num) ->
		# put num back in stackBox
		$stackBox = $("#stack")
		console.log("num is " + num)
		if $stackBox.val() != ''
			$stackBox.val($stackBox.val() + '\n' + num)
		else
			$stackBox.val(num)

	isNumber = (n) ->
		return !isNaN(parseFloat(n)) and isFinite(n)