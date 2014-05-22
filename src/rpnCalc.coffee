class rpnCalc
	constructor: ->
		@stack = []
		@index = 0
			
	returnIndex: ->
		return @index

	getStackAtIndex: (query) ->
		return @stack[query]

	push: (numToPush) ->
		@stack[@index] = numToPush
		@index++

	pop: ->
		if @index > 0
			@index--
			return @stack[@index]
		else
			return false
			
	add: ->
		if @index > 1
			numOne = @pop()
			numTwo = @pop()
			return numOne + numTwo
		else
			return false

	subtract: ->
		if @index > 1
			numOne = @pop()
			numTwo = @pop()
			return numOne - numTwo
		else
			return false

	sum: (prevSum) ->
		if @index > 0
			prevSum ?= 0
			@sum(@pop() + prevSum)
		else
			if prevSum?
				return prevSum

			else
				return false