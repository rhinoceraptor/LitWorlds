###
CoffeeScript shortcut:
constructor (prop) ->
	@prop = prop

is equal to:

constructor (@prop) ->
###

class Item
	constructor: (@id, @title, @desc, @cost) ->

	getQuantity: (item_id) ->
		for i in @items
			return i.quantity if i.item_id is item_id
		false

	add: (item, quantity) ->
		if @itemExistsInBasket(item.id)
			cutItemLoc = @getItemLocation item.id
			@items[curItemLoc].quantity += quantity
		else
			@items.push({
				"item_id" : item_id,
				"quantity" : quantity
				})
			@distinct_count++
		@total_count += quantity

	itemExistsInBasket: (item_id) ->
		for i in @items
			return true if i.item_id is item_id
		false

	getItemLocation: (item_id) ->
		count = 0
		for i in @items
			return count if i.item_id is item_id
			count++
		false
