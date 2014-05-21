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
		@index--
		return @stack[@index]