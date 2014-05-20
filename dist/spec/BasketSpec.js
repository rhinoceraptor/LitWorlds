// Generated by CoffeeScript 1.7.1

/*
JavaScript format for Jasmine testing:
describe("Basket Class", function() 
{
	// individual tests ge here	
})
 */
var test;

test = {};

beforeEach(function() {
  var item2;
  test.basket = new Basket();
  test.item = new Item(0x1, "Macbook Air", "Newer, thinner, better", 799);
  item2 = new Item(0x2, "Magic Trackpad", "Better than a mouse", 50);
  return test.basket.add(item2, 1);
});


/*
We want to be able to:
1) Add an item
2) Remove an item
3) Calculate the total price of all the items
 */

describe("Basket Class", function() {
  it("should be able to add a new item to basket", function() {
    var priorCountVal;
    priorCountVal = test.basket.distinctCount;
    test.basket.add(test.item, 1);
    return expect(test.basket.distinctCount).toEqual(priorCountVal + 1);
  });
  return it("should be able to update quantity when adding an item already in the basket", function() {
    var priorCountVal;
    priorCountVal = test.basket.getQuantity(0x1);
    test.basket.add(test.item, 1);
    return expect(test.basket.getQuantity(0x1)).toEqual(priorCountVal + 1);
  });
});
