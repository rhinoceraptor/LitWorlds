test = {}

beforeEach ->
	test.calc = new rpnCalc()

describe "RPN class", ->

# Test simple stack functionality
###############################################################################
	it "should have index of 0 at start", ->
		expect(test.calc.returnIndex()).toEqual 0

	it "should be able to push numbers to the stack", ->
		test.calc.push(37)
		test.calc.push(67)
		expect(test.calc.getStackAtIndex(1)).toEqual 67

	it "should increment the index when pushing numbers", ->
		test.calc.push(52)
		test.calc.push(67)
		expect(test.calc.returnIndex()).toEqual 2

	it "should be able to pop numbers from the stack", ->
		test.calc.push(24)
		expect(test.calc.pop()).toEqual 24

	it "should decrement the index when popping numbers", ->
								# index starts at 0
		test.calc.push(106)		# index == 1
		test.calc.push(28)		# index == 2
		test.calc.pop()			# index == 1
		expect(test.calc.returnIndex()).toEqual 1

	it "should return false if an impossible pop is attempted", ->
		expect(test.calc.pop()).toEqual(false)

# Test add function
###############################################################################

	it "should be able to perform an add operation", ->
		test.calc.push(2000)
		test.calc.push(4923)
		expect(test.calc.add()).toEqual(6923)

	it "should return false if an add is not possible", ->
		test.calc.push(3)
		expect(test.calc.add()).toEqual(false)

# Test subtract function
###############################################################################

	it "should be able to perform a subtract operation", ->
		test.calc.push(12)
		test.calc.push(300)
		expect(test.calc.sub()).toEqual(288)

	it "should return false if a subtract is not possible", ->
		test.calc.push(3)
		expect(test.calc.sub()).toEqual(false)

# Test multiply function
###############################################################################

	it "should be able to perform a multiply operation", ->
		test.calc.push(12)
		test.calc.push(300)
		expect(test.calc.mult()).toEqual(3600)

	it "should return false if a multiply is not possible", ->
		test.calc.push(3)
		expect(test.calc.mult()).toEqual(false)

# Test divide function
###############################################################################

	it "should be able to perform a divide operation", ->
		test.calc.push(5)
		test.calc.push(5)
		expect(test.calc.div()).toEqual(1)

	it "should return false if a divide is not possible", ->
		test.calc.push(3)
		expect(test.calc.div()).toEqual(false)

# Test sum function
###############################################################################

	it "should return false for sum if the stack is 0", ->
		expect(test.calc.sum()).toEqual(false)

	it "should be able to sum a single number on the stack", ->
		test.calc.push(1)
		expect(test.calc.sum()).toEqual(1)

	it "should be able to sum several numbers on the stack", ->
		test.calc.push(-3)
		test.calc.push(6)
		test.calc.push(9)
		expect(test.calc.sum()).toEqual(12)

# Test exponent function
###############################################################################

	it "should be able to exponentiate", ->
		test.calc.push(2)
		test.calc.push(4)
		expect(test.calc.exp()).toEqual(16)

	it "should return false if a exponentiation is not possible", ->
		test.calc.push(3)
		expect(test.calc.exp()).toEqual(false)

# Test modulus function
###############################################################################

	it "should be able to perform a modulus", ->
		test.calc.push(7)
		test.calc.push(32)
		expect(test.calc.mod()).toEqual(4)

	it "should return false if a exponentiation is not possible", ->
		test.calc.push(3)
		expect(test.calc.mod()).toEqual(false)

# Test sqrt function
###############################################################################

	it "should be able to perform a square root function", ->
		test.calc.push(64)
		expect(test.calc.sqrt()).toEqual(8)

	it "should return false if a square root it not possible", ->
		expect(test.calc.sqrt()).toEqual(false)