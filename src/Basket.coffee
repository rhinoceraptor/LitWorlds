class Basket
	items: []
	distinctCount: 0
	totalCount: 0

	add: (item, quantity) ->
		@items.push item
		@distinctCount++
		@totalCount++