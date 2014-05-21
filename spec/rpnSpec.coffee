test = {}

beforeEach ->
	test.calc = new rpnCalc()

describe "RPN class", ->

	it "should have index of 0 at start", ->
		expect(test.calc.returnIndex()).toEqual 0

	it "should be able to push numbers to the stack", ->
		test.calc.push(37)
		expect(test.calc.getStackAtIndex(0)).toEqual 37

	it "should be able to increment the index when pushing numbers", ->
		test.calc.push(52)
		expect(test.calc.returnIndex()).toEqual 1

	it "should be able to pop numbers from the stack", ->
		test.calc.push(24)
		expect(test.calc.pop()).toEqual 24

	it "decrement the index when popping numbers", ->
		test.calc.push(106)
		test.calc.push(28)
		test.calc.pop()
		expect(test.calc.returnIndex()).toEqual 1