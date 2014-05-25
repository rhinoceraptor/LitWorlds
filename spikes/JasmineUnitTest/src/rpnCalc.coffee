class rpnCalc
	constructor: ->
		@stack = []
		@index = 0
			
	returnIndex: ->
		return @index

	getStackAtIndex: (query) ->
		return @stack[query]

	operationIsPossible: ->
		if @index > 1
			return true
		else
			return false

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
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numTwo + numOne
			@push(result)
			return result
		else
			return false

	sub: ->
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numTwo - numOne
			@push(result)
			return result
		else
			return false

	mult: ->
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numTwo * numOne
			@push(result)
			return result
		else
			return false

	div: ->
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numTwo / numOne
			@push(result)
			return result
		else
			return false

	sum: (prevSum) ->
		if @index > 0
			prevSum ?= 0
			@sum(@pop() + prevSum)
		else
			if prevSum?
				@push prevSum
				return prevSum

			else
				return false

	exp: ->
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numOne ** numTwo
			@push(result)
			return result
		else
			return false

	mod: ->
		if @operationIsPossible()
			numOne = @pop()
			numTwo = @pop()
			result = numOne %% numTwo
			@push(result)
			return result
		else
			return false

	sqrt: ->
		if @index >= 0
			result = Math.sqrt(@pop())
			@push result
			return result
		else
			return false

	clr: ->
		for i in [0..@index]
			@pop()