/*:
[Previous](@previous)
______________________

# Functions

Functions are self-contained chunks of code that perform a specific task. You give a function a name that identifies what it does, and this name is used to “call” the function to perform its task when needed.

Swift’s unified function syntax is flexible enough to express anything from a simple C-style function with no parameter names to a complex Objective-C-style method with local and external parameter names for each parameter. Parameters can provide default values to simplify function calls and can be passed as in-out parameters, which modify a passed variable once the function has completed its execution.

Every function in Swift has a type, consisting of the function’s parameter types and return type. You can use this type like any other type in Swift, which makes it easy to pass functions as parameters to other functions, and to return functions from functions. Functions can also be written within other functions to encapsulate useful functionality within a nested function scope.

## Defining and Calling Functions

When you define a function, you can optionally define one or more named, typed values that the function takes as input, known as parameters. You can also optionally define a type of value that the function will pass back as output when it is done, known as its return type.

Every function has a function name, which describes the task that the function performs. To use a function, you “call” that function with its name and pass it input values (known as arguments) that match the types of the function’s parameters. A function’s arguments must always be provided in the same order as the function’s parameter list.

The function in the example below is called sayHello(_:), because that’s what it does—it takes a person’s name as input and returns a greeting for that person. To accomplish this, you define one input parameter—a String value called personName—and a return type of String, which will contain a greeting for that person:
*/
func sayHello(personName: String) -> String {
	let greeting = "Hello, " + personName + "!"
	return greeting
}
/*:
All of this information is rolled up into the function’s definition, which is prefixed with the func keyword. You indicate the function’s return type with the return arrow -> (a hyphen followed by a right angle bracket), which is followed by the name of the type to return.
	
The definition describes what the function does, what it expects to receive, and what it returns when it is done. The definition makes it easy for the function to be called unambiguously from elsewhere in your code:
*/
print(sayHello("Anna"))
// prints "Hello, Anna!"
print(sayHello("Brian"))
// prints "Hello, Brian!"
/*:
You call the sayHello(_:) function by passing it a String argument value in parentheses, such as sayHello("Anna"). Because the function returns a String value, sayHello(_:) can be wrapped in a call to the print(_:separator:terminator:) function to print that string and see its return value, as shown above.

The body of the sayHello(_:) function starts by defining a new String constant called greeting and setting it to a simple greeting message for personName. This greeting is then passed back out of the function using the return keyword. As soon as return greeting is called, the function finishes its execution and returns the current value of greeting.

You can call the sayHello(_:) function multiple times with different input values. The example above shows what happens if it is called with an input value of "Anna", and an input value of "Brian". The function returns a tailored greeting in each case.

To simplify the body of this function, combine the message creation and the return statement into one line:
*/
func sayHelloAgain(personName: String) -> String {
	return "Hello again, " + personName + "!"
}
print(sayHelloAgain("Anna"))
// prints "Hello again, Anna!"
/*:
## Function Parameters and Return Values

Function parameters and return values are extremely flexible in Swift. You can define anything from a simple utility function with a single unnamed parameter to a complex function with expressive parameter names and different parameter options.

### Functions Without Parameters

Functions are not required to define input parameters. Here’s a function with no input parameters, which always returns the same String message whenever it is called:
*/
func sayHelloWorld() -> String {
	return "hello, world"
}
print(sayHelloWorld())
// prints "hello, world"
/*:
The function definition still needs parentheses after the function’s name, even though it does not take any parameters. The function name is also followed by an empty pair of parentheses when the function is called.

### Functions With Multiple Parameters

Functions can have multiple input parameters, which are written within the function’s parentheses, separated by commas.

This function takes a person’s name and whether they have already been greeted as input, and returns an appropriate greeting for that person:
*/
func sayHello(personName: String, alreadyGreeted: Bool) -> String {
	if alreadyGreeted {
		return sayHelloAgain(personName)
	} else {
		return sayHello(personName)
	}
}
print(sayHello("Tim", alreadyGreeted: true))
// prints "Hello again, Tim!"
/*:

[Function Parameter Names]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID166 ""

You call the sayHello(_:alreadyGreeted:) function by passing it both a String argument value and a Bool argument value labeled alreadyGreeted in parentheses, separated by commas.

When calling a function with more than one parameter, any argument after the first is labeled according to its corresponding parameter name. Function parameter naming is described in more detail in [Function Parameter Names].

### Functions Without Return Values

Functions are not required to define a return type. Here’s a version of the sayHello(_:) function, called sayGoodbye(_:), which prints its own String value rather than returning it:
*/
func sayGoodbye(personName: String) {
	print("Goodbye, \(personName)!")
//	return ()
}
sayGoodbye("Dave")
// prints "Goodbye, Dave!"
/*:
Because it does not need to return a value, the function’s definition does not include the return arrow (->) or a return type.
	
**Note**

> Strictly speaking, the sayGoodbye(_:) function does still return a value, even though no return value is defined. Functions without a defined return type return a special value of type Void. This is simply an empty tuple, in effect a tuple with zero elements, which can be written as ().

The return value of a function can be ignored when it is called:
*/
func printAndCount(stringToPrint: String) -> Int {
	print(stringToPrint)
	return stringToPrint.characters.count
}
func printWithoutCounting(stringToPrint: String) {
	printAndCount(stringToPrint)
}
printAndCount("hello, world")
// prints "hello, world" and returns a value of 12
printWithoutCounting("hello, world")
// prints "hello, world" but does not return a value
/*:
The first function, printAndCount(_:), prints a string, and then returns its character count as an Int. The second function, printWithoutCounting, calls the first function, but ignores its return value. When the second function is called, the message is still printed by the first function, but the returned value is not used.

**Note**

> Return values can be ignored, but a function that says it will return a value must always do so. A function with a defined return type cannot allow control to fall out of the bottom of the function without returning a value, and attempting to do so will result in a compile-time error.

### Functions with Multiple Return Values

You can use a tuple type as the return type for a function to return multiple values as part of one compound return value.
	
The example below defines a function called minMax(_:), which finds the smallest and largest numbers in an array of Int values:
*/
func minMax(array: [Int]) -> (min: Int, max: Int) {
	var currentMin = array[0]
	var currentMax = array[0]
	for value in array[1..<array.count] {
		if value < currentMin {
			currentMin = value
		} else if value > currentMax {
			currentMax = value
		}
	}
	return (currentMin, currentMax)
}
func minmax(array: [Int]) -> (min:Int, max: Int)? {
	guard array.count != 0 else { return nil }
	return (array.sort(<)[0], array.sort(>)[0])
}
/*:
The minMax(_:) function returns a tuple containing two Int values. These values are labeled min and max so that they can be accessed by name when querying the function’s return value.
	
The body of the minMax(_:) function starts by setting two working variables called currentMin and currentMax to the value of the first integer in the array. The function then iterates over the remaining values in the array and checks each value to see if it is smaller or larger than the values of currentMin and currentMax respectively. Finally, the overall minimum and maximum values are returned as a tuple of two Int values.

Because the tuple’s member values are named as part of the function’s return type, they can be accessed with dot syntax to retrieve the minimum and maximum found values:
*/
let bounds = minMax([8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")
// prints "min is -6 and max is 109"
if let bounds1 = minmax([8, -6, 2, 109, 3, 71]) {
	let max = bounds1.max
	let min = bounds1.min
}
let bounds2 = minmax([])
bounds2.debugDescription
/*:
Note that the tuple’s members do not need to be named at the point that the tuple is returned from the function, because their names are already specified as part of the function’s return type.
	
### Optional Tuple Return Types

If the tuple type to be returned from a function has the potential to have “no value” for the entire tuple, you can use an optional tuple return type to reflect the fact that the entire tuple can be nil. You write an optional tuple return type by placing a question mark after the tuple type’s closing parenthesis, such as (Int, Int)? or (String, Int, Bool)?.

**Note**

> An optional tuple type such as (Int, Int)? is different from a tuple that contains optional types such as (Int?, Int?). With an optional tuple type, the entire tuple is optional, not just each individual value within the tuple.

The minMax(_:) function above returns a tuple containing two Int values. However, the function does not perform any safety checks on the array it is passed. If the array argument contains an empty array, the minMax(_:) function, as defined above, will trigger a runtime error when attempting to access array[0].

To handle this “empty array” scenario safely, write the minMax(_:) function with an optional tuple return type and return a value of nil when the array is empty:
*/
func minMax1(array: [Int]) -> (min: Int, max: Int)? {
	if array.isEmpty { return nil }
	var currentMin = array[0]
	var currentMax = array[0]
	for value in array[1..<array.count] {
		if value < currentMin {
			currentMin = value
		} else if value > currentMax {
			currentMax = value
		}
	}
	return (currentMin, currentMax)
}
/*:
You can use optional binding to check whether this version of the minMax(_:) function returns an actual tuple value or nil:
*/
if let bounds = minMax1([8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
// prints "min is -6 and max is 109"
/*:
## Function Parameter Names

Function parameters have both an external parameter name and a local parameter name. An external parameter name is used to label arguments passed to a function call. A local parameter name is used in the implementation of the function.
*/
func someFunction(firstParameterName: Int, secondParameterName: Int) {
	// function body goes here
	// firstParameterName and secondParameterName refer to
	// the argument values for the first and second parameters
}
someFunction(1, secondParameterName: 2)
/*:
By default, the first parameter omits its external name, and the second and subsequent parameters use their local name as their external name. All parameters must have unique local names. Although it’s possible for multiple parameters to have the same external name, unique external names help make your code more readable.

### Specifying External Parameter Names

You write an external parameter name before the local parameter name it supports, separated by a space:
*/
func someFunction(externalParameterName localParameterName: Int) {
	// function body goes here, and can use localParameterName
	// to refer to the argument value for that parameter
}
/*:
**Note**

> If you provide an external parameter name for a parameter, that external name must always be used when you call the function.

Here’s a version of the sayHello(_:) function that takes the names of two people and returns a greeting for both of them:
*/
func sayHello(to person: String, and anotherPerson: String) -> String {
	return "Hello \(person) and \(anotherPerson)!"
}
print(sayHello(to: "Bill", and: "Ted"))
// prints "Hello Bill and Ted!"
/*:
By specifying external parameter names for both parameters, both the first and second arguments to the sayHello(to:and:) function must be labeled when you call it.

The use of external parameter names can allow a function to be called in an expressive, sentence-like manner, while still providing a function body that is readable and clear in intent.

### Omitting External Parameter Names

If you do not want to use an external name for the second or subsequent parameters of a function, write an underscore (_) instead of an explicit external name for that parameter.
*/
func someFunction(firstParameterName: Int, _ secondParameterName: Int) {
	// function body goes here
	// firstParameterName and secondParameterName refer to
	// the argument values for the first and second parameters
}
someFunction(1, 2)
/*:
**Note**

> Because the first parameter omits its external parameter name by default, explicitly writing an underscore is extraneous.

### Default Parameter Values

You can define a default value for any parameter in a function by assigning a value to the parameter after that parameter’s type. If a default value is defined, you can omit that parameter when calling the function.
*/
func someFunction(parameterWithDefault: Int = 12) {
	// function body goes here
	// if no arguments are passed to the function call,
	// value of parameterWithDefault is 12
}
someFunction(6) // parameterWithDefault is 6
someFunction() // parameterWithDefault is 12
/*:
**Note**

> Place parameters with default values at the end of a function’s parameter list. This ensures that all calls to the function use the same order for their nondefault arguments, and makes it clear that the same function is being called in each case.

### Variadic Parameters

A variadic parameter accepts zero or more values of a specified type. You use a variadic parameter to specify that the parameter can be passed a varying number of input values when the function is called. Write variadic parameters by inserting three period characters (...) after the parameter’s type name.

The values passed to a variadic parameter are made available within the function’s body as an array of the appropriate type. For example, a variadic parameter with a name of numbers and a type of Double... is made available within the function’s body as a constant array called numbers of type [Double].

The example below calculates the arithmetic mean (also known as the average) for a list of numbers of any length:
*/
func arithmeticMean(numbers: Double...) -> Double {
	var total: Double = 0
	for number in numbers {
		total += number
	}
	return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// returns 3.0, which is the arithmetic mean of these five numbers
arithmeticMean(3, 8.25, 18.75)
// returns 10.0, which is the arithmetic mean of these three numbers
func arithmeticMean(numbers: [Double]) -> Double {
	var total: Double = 0
	for number in numbers {
		total += number
	}
	return total / Double(numbers.count)
}
arithmeticMean() //return nan (not a number)

/*:
**Note**

> A function may have at most one variadic parameter.

### Constant and Variable Parameters

Function parameters are constants by default. Trying to change the value of a function parameter from within the body of that function results in a compile-time error. This means that you can’t change the value of a parameter by mistake.

**以下這段話在2.2版的手冊中被刪除，但語法上仍可使用**

**However, sometimes it is useful for a function to have a variable copy of a parameter’s value to work with. You can avoid defining a new variable yourself within the function by specifying one or more parameters as variable parameters instead. Variable parameters are available as variables rather than as constants, and give a new modifiable copy of the parameter’s value for your function to work with.**

**Define variable parameters by prefixing the parameter name with the var keyword:**
*/
func alignRight(var string: String, totalLength: Int, pad: Character) -> String {
	let amountToPad = totalLength - string.characters.count
	if amountToPad < 1 {
		return string
	}
	let padString = String(pad)
	for _ in 1...amountToPad {
		string = padString + string
	}
	return string
}
let originalString = "hello"
let paddedString = alignRight(originalString, totalLength: 10, pad: "-")
originalString
// paddedString is equal to "-----hello"
// originalString is still equal to "hello"
/*:
**This example defines a new function called alignRight(_:totalLength:pad:), which aligns an input string to the right edge of a longer output string. Any space on the left is filled with a specified padding character. In this example, the string "hello" is converted to the string "-----hello".**

**The alignRight(_:totalLength:pad:) function defines the input parameter string to be a variable parameter. This means that string is now available as a local variable, initialized with the passed-in string value, and can be manipulated within the body of the function.**

**The function starts by working out how many characters need to be added to the left of string in order to right-align it within the overall string. This value is stored in a local constant called amountToPad. If no padding is needed (that is, if amountToPad is less than 1), the function simply returns the input value of string without any padding.**

**Otherwise, the function creates a new temporary String constant called padString, initialized with the pad character, and adds amountToPad copies of padString to the left of the existing string. (A String value cannot be added on to a Character value, and so the padString constant is used to ensure that both sides of the + operator are String values.)**

**Note**

> **The changes you make to a variable parameter do not persist beyond the end of each call to the function, and are not visible outside the function’s body. The variable parameter only exists for the lifetime of that function call.**

### In-Out Parameters

[In-Out Parameters]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-ID545 ""

Variable parameters, as described above, can only be changed within the function itself. If you want a function to modify a parameter’s value, and you want those changes to persist after the function call has ended, define that parameter as an in-out parameter instead.

You write an in-out parameter by placing the inout keyword at the start of its parameter definition. An in-out parameter has a value that is passed in to the function, is modified by the function, and is passed back out of the function to replace the original value. For a detailed discussion of the behavior of in-out parameters and associated compiler optimizations, see [In-Out Parameters].

You can only pass a variable as the argument for an in-out parameter. You cannot pass a constant or a literal value as the argument, because constants and literals cannot be modified. You place an ampersand (&) directly before a variable’s name when you pass it as an argument to an in-out parameter, to indicate that it can be modified by the function.

**Note**

> In-out parameters cannot have default values, and variadic parameters cannot be marked as inout. If you mark a parameter as inout, it cannot also be marked as var or let.

Here’s an example of a function called swapTwoInts(_:_:), which has two in-out integer parameters called a and b:
*/
func swapTwoInts(inout a: Int, inout _ b: Int) {
	let temporaryA = a
	a = b
	b = temporaryA
}
/*:
The swapTwoInts(_:_:) function simply swaps the value of b into a, and the value of a into b. The function performs this swap by storing the value of a in a temporary constant called temporaryA, assigning the value of b to a, and then assigning temporaryA to b.

You can call the swapTwoInts(_:_:) function with two variables of type Int to swap their values. Note that the names of someInt and anotherInt are prefixed with an ampersand when they are passed to the swapTwoInts(_:_:) function:
*/
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// prints "someInt is now 107, and anotherInt is now 3"
/*:
The example above shows that the original values of someInt and anotherInt are modified by the swapTwoInts(_:_:) function, even though they were originally defined outside of the function.

**Note**

> In-out parameters are not the same as returning a value from a function. The swapTwoInts example above does not define a return type or return a value, but it still modifies the values of someInt and anotherInt. In-out parameters are an alternative way for a function to have an effect outside of the scope of its function body.

## Function Types

Every function has a specific function type, made up of the parameter types and the return type of the function.
	
For example:
*/
func addTwoInts(a: Int, _ b: Int) -> Int {
	return a + b
}
func multiplyTwoInts(a: Int, _ b: Int) -> Int {
	return a * b
}
/*:
This example defines two simple mathematical functions called addTwoInts and multiplyTwoInts. These functions each take two Int values, and return an Int value, which is the result of performing an appropriate mathematical operation.

The type of both of these functions is (Int, Int) -> Int. This can be read as:

“A function type that has two parameters, both of type Int, and that returns a value of type Int.”

Here’s another example, for a function with no parameters or return value:
*/
func printHelloWorld() {
	print("hello, world")
}
/*:
The type of this function is () -> Void, or “a function that has no parameters, and returns Void.”

### Using Function Types

You use function types just like any other types in Swift. For example, you can define a constant or variable to be of a function type and assign an appropriate function to that variable:
*/
var mathFunction: (Int, Int) -> Int = addTwoInts
/*:
This can be read as:

“Define a variable called mathFunction, which has a type of ‘a function that takes two Int values, and returns an Int value.’ Set this new variable to refer to the function called addTwoInts.”

The addTwoInts(_:_:) function has the same type as the mathFunction variable, and so this assignment is allowed by Swift’s type-checker.

You can now call the assigned function with the name mathFunction:
*/
print("Result: \(mathFunction(2, 3))")
// prints "Result: 5"
/*:
A different function with the same matching type can be assigned to the same variable, in the same way as for non-function types:
*/
mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")
// prints "Result: 6"
/*:
As with any other type, you can leave it to Swift to infer the function type when you assign a function to a constant or variable:
*/
let anotherMathFunction = addTwoInts
// anotherMathFunction is inferred to be of type (Int, Int) -> Int
/*:
### Function Types as Parameter Types

You can use a function type such as (Int, Int) -> Int as a parameter type for another function. This enables you to leave some aspects of a function’s implementation for the function’s caller to provide when the function is called.

Here’s an example to print the results of the math functions from above:
*/
func printMathResult(mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
	print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// prints "Result: 8"
printMathResult(multiplyTwoInts, 3, 5)
// prints "Result: 15"
/*:
This example defines a function called printMathResult(_:_:_:), which has three parameters. The first parameter is called mathFunction, and is of type (Int, Int) -> Int. You can pass any function of that type as the argument for this first parameter. The second and third parameters are called a and b, and are both of type Int. These are used as the two input values for the provided math function.

When printMathResult(_:_:_:) is called, it is passed the addTwoInts(_:_:) function, and the integer values 3 and 5. It calls the provided function with the values 3 and 5, and prints the result of 8.

The role of printMathResult(_:_:_:) is to print the result of a call to a math function of an appropriate type. It doesn’t matter what that function’s implementation actually does—it matters only that the function is of the correct type. This enables printMathResult(_:_:_:) to hand off some of its functionality to the caller of the function in a type-safe way.

### Function Types as Return Types

You can use a function type as the return type of another function. You do this by writing a complete function type immediately after the return arrow (->) of the returning function.
	
The next example defines two simple functions called stepForward(_:) and stepBackward(_:). The stepForward(_:) function returns a value one more than its input value, and the stepBackward(_:) function returns a value one less than its input value. Both functions have a type of (Int) -> Int:
*/
func stepForward(input: Int) -> Int {
	return input + 1
}
func stepBackward(input: Int) -> Int {
	return input - 1
}
/*:
Here’s a function called chooseStepFunction(_:), whose return type is “a function of type (Int) -> Int”. The chooseStepFunction(_:) function returns the "stepForward(_:) function" or the "stepBackward(_:) function" based on a Boolean parameter called backwards:
*/
func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
	return backwards ? stepBackward : stepForward
}
/*:
You can now use chooseStepFunction(_:) to obtain a function that will step in one direction or the other:
*/
var currentValue = 3
let moveNearerToZero = chooseStepFunction(currentValue > 0)
// moveNearerToZero now refers to the stepBackward() function
moveNearerToZero(currentValue)
/*:
The preceding example determines whether a positive or negative step is needed to move a variable called currentValue progressively closer to zero. currentValue has an initial value of 3, which means that currentValue > 0 returns true, causing chooseStepFunction(_:) to return the stepBackward(_:) function. A reference to the returned function is stored in a constant called moveNearerToZero.

Now that moveNearerToZero refers to the correct function, it can be used to count to zero:
*/
print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
	print("\(currentValue)... ")
	currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// 3...
// 2...
// 1...
// zero!
/*:
## Nested Functions

All of the functions you have encountered so far in this chapter have been examples of global functions, which are defined at a global scope. You can also define functions inside the bodies of other functions, known as nested functions.

Nested functions are hidden from the outside world by default, but can still be called and used by their enclosing function. An enclosing function can also return one of its nested functions to allow the nested function to be used in another scope.

You can rewrite the chooseStepFunction(_:) example above to use and return nested functions:
*/
func chooseStepFunction1(backwards: Bool) -> (Int) -> Int {
	func stepForward(input: Int) -> Int { return input + 1 }
	func stepBackward(input: Int) -> Int { return input - 1 }
	return backwards ? stepBackward : stepForward
}
var currentValue1 = -4
let moveNearerToZero1 = chooseStepFunction1(currentValue1 > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue1 != 0 {
	print("\(currentValue1)... ")
	currentValue1 = moveNearerToZero1(currentValue1)
}
print("zero!")
// -4...
// -3...
// -2...
// -1...
// zero!

func moveTozero(from from: Int) -> Int {
	func stepForward(input: Int) -> Int { return input + 1 }
	func stepBackward(input: Int) -> Int { return input - 1 }
	func chooseStepFunction()-> (Int) -> Int {
		return from > 0 ? stepBackward : stepForward
	}
	return from == 0 ? 0 : moveTozero(from: chooseStepFunction()(from))
}
moveTozero(from: -4)

/*:
______________________
[Next](@next)
*/
//練習
import Foundation
let pi = M_PI

func sumOfInt(countToN n: Int) -> Int {
	var sum = 0
	for i in 1...n {
		sum += i
	}
	return sum
}
sumOfInt(countToN: 10)
func sumOfInt1(countToN n: Int) -> Int {
	guard n != 1 else { return 1 }
	return sumOfInt(countToN: n-1) + n
}
sumOfInt1(countToN: 10)

func slopOf(f y: (Double) -> Double, at x: Double) -> Double {
	let dx: Double = 0.00000001
	let dy: Double = y(x + dx) - y(x)
	return dy / dx
}
slopOf(f: sin, at: 0)
slopOf(f: sin, at: pi / 2)
slopOf(f: cos, at: 0)
slopOf(f: cos, at: pi / 2)

func area(f y: (Double) -> Double, from x0: Double, to x1: Double) -> Double {
	var area: Double = 0
	let dx = 0.0001
	var x = x0
	repeat {
		area += y(x) * 0.0001
		x += dx
	} while x < x1
	return area
}
area(f: sin, from: 0,to: pi * 2)

func line1(x: Double) -> Double {
	return 5 * x
}

slopOf(f: line1, at: 0)
area(f: line1, from: 0, to: 1)

func curve1(x: Double) -> Double {
	return 3 * x * x + 5 * x - 6
}

slopOf(f: curve1, at: 0)
area(f: curve1, from: 0, to: 3)

func fibonacci(n: Int) -> Int {
	guard n > 2 else { return 1 }
	return fibonacci(n - 1) + fibonacci(n - 2)
}

func fibonacciArray(count n: Int) -> [Int] {
	guard n != 1 else { return [1] }
	return fibonacciArray(count: n - 1) + [fibonacci(n)]
}
fibonacci(10)
fibonacciArray(count: 10)
func fibonacciArray1(count n: Int) -> [Int] {
	var array = [1, 1]
	for i in 2..<n {
		array += [array[i - 1] + array[i - 2]]
	}
	return array
}
fibonacciArray1(count: 30)

// 從上述兩種fibonacciArray的方法中可以發現採用遞迴方式的演算法速度慢

