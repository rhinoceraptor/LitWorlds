###
JavaScript format for Jasmine testing:
describe("Basket Class", function() 
{
	// individual tests ge here	
})
###

test = {}

beforeEach ->
	test.basket = new Basket()
	test.item = new Item 0o001, "Macbook Air", "Newer, thinner, better", 799
	item2 = new Item 0o002, "Magic Trackpad", "Better than a mouse", 50
	test.basket.add item2, 1

###
We want to be able to:
1) Add an item
2) Remove an item
3) Calculate the total price of all the items
###

describe "Basket Class", ->
	# individual tests go here

	# Get the current amount of items in the basket
	# Add the test item
	# Expect the distinct count to be one more than it was
	it "should be able to add a new item to basket", ->
		priorCountVal = test.basket.distinctCount
		test.basket.add test.item, 1
		expect(test.basket.distinctCount).toEqual priorCountVal + 1

	# Get the quantity of items in the basket with id 001
	# Add one more of that item to the basket
	# Expect the quantity to be one more than it was (using Jasmine's toEqual method)
	it "should be able to update quantity when adding an item already in the basket", ->
		priorCountVal = test.basket.getQuantity(0o001)
		test.basket.add(test.item, 1)
		expect(test.basket.getQuantity(0o001)).toEqual priorCountVal + 1

