$ ->
	console.log('ready')
	container = {}
	container.rpnCalc = new rpnCalc()

	$("#Enter").click ->
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
		console.log(">>>" + @id)
		$entryBox = $("#entry")
		oldEntry = $entryBox.val()
		$entryBox.val(oldEntry + @id)
		console.log(oldEntry + @id)

	$(".operator").click ->
		if container.rpnCalc.operationIsPossible()

			# remove last two lines from stackBox
			$stackBox = $("#stack")
			stackText = $stackBox.val().split('\n')
			numLines = container.rpnCalc.returnIndex() - 1
			stackText.splice(numLines - 2, numLines)
			console.log("stackText = " + stackText)
			$stackBox.val(stackText.join('\n'))

			console.log(">" + @id.toString() + "<")
			switch @id.toString()
				when '+' 
					result = container.rpnCalc.add()
					console.log("add")
				when '-' 
					result = container.rpnCalc.sub()
				when '*' 
					result = container.rpnCalc.mult()
				when '/' 
					result = container.rpnCalc.div()

			# put result back in stackBox
			console.log("result is " + result)
			if $stackBox.val() != ''
				$stackBox.val($stackBox.val() + '\n' + result)
			else
				$stackBox.val(result)

	isNumber = (n) ->
  		return !isNaN(parseFloat(n)) and isFinite(n)