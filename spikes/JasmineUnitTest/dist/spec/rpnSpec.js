// Generated by CoffeeScript 1.7.1
var test;

test = {};

beforeEach(function() {
  return test.calc = new rpnCalc();
});

describe("RPN class", function() {
  it("should have index of 0 at start", function() {
    return expect(test.calc.returnIndex()).toEqual(0);
  });
  it("should be able to push numbers to the stack", function() {
    test.calc.push(37);
    test.calc.push(67);
    return expect(test.calc.getStackAtIndex(1)).toEqual(67);
  });
  it("should increment the index when pushing numbers", function() {
    test.calc.push(52);
    test.calc.push(67);
    return expect(test.calc.returnIndex()).toEqual(2);
  });
  it("should be able to pop numbers from the stack", function() {
    test.calc.push(24);
    return expect(test.calc.pop()).toEqual(24);
  });
  it("should decrement the index when popping numbers", function() {
    test.calc.push(106);
    test.calc.push(28);
    test.calc.pop();
    return expect(test.calc.returnIndex()).toEqual(1);
  });
  it("should return false if an impossible pop is attempted", function() {
    return expect(test.calc.pop()).toEqual(false);
  });
  it("should be able to perform an add operation", function() {
    test.calc.push(4923);
    test.calc.push(2000);
    return expect(test.calc.add()).toEqual(6923);
  });
  it("should return false if an add is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.add()).toEqual(false);
  });
  it("should be able to perform a subtract operation", function() {
    test.calc.push(300);
    test.calc.push(12);
    return expect(test.calc.sub()).toEqual(288);
  });
  it("should return false if a subtract is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.sub()).toEqual(false);
  });
  it("should be able to perform a multiply operation", function() {
    test.calc.push(300);
    test.calc.push(12);
    return expect(test.calc.mult()).toEqual(3600);
  });
  it("should be able to perform a floating point multiply operation", function() {
    test.calc.push(0.5);
    test.calc.push(0.25);
    return expect(test.calc.mult()).toEqual(0.125);
  });
  it("should return false if a multiply is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.mult()).toEqual(false);
  });
  it("should be able to perform a divide operation", function() {
    test.calc.push(5);
    test.calc.push(5);
    return expect(test.calc.div()).toEqual(1);
  });
  it("should be able to perform a floating point divide", function() {
    test.calc.push(1);
    test.calc.push(7);
    return expect(test.calc.div()).toEqual(0.14285714285714285);
  });
  it("should return false if a divide is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.div()).toEqual(false);
  });
  it("should return false for sum if the stack is 0", function() {
    return expect(test.calc.sum()).toEqual(false);
  });
  it("should be able to sum a single number on the stack", function() {
    test.calc.push(1);
    return expect(test.calc.sum()).toEqual(1);
  });
  it("should be able to sum several numbers on the stack", function() {
    test.calc.push(-3);
    test.calc.push(6);
    test.calc.push(9);
    return expect(test.calc.sum()).toEqual(12);
  });
  it("should be able to exponentiate", function() {
    test.calc.push(4);
    test.calc.push(2);
    return expect(test.calc.exp()).toEqual(16);
  });
  it("should return false if a exponentiation is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.exp()).toEqual(false);
  });
  it("should be able to perform a modulus", function() {
    test.calc.push(7);
    test.calc.push(32);
    return expect(test.calc.mod()).toEqual(4);
  });
  it("should return false if a exponentiation is not possible", function() {
    test.calc.push(3);
    return expect(test.calc.mod()).toEqual(false);
  });
  it("should be able to perform a square root function", function() {
    test.calc.push(64);
    return expect(test.calc.sqrt()).toEqual(8);
  });
  return it("should return false if a square root it not possible", function() {
    return expect(test.calc.sqrt()).toEqual(false);
  });
});
