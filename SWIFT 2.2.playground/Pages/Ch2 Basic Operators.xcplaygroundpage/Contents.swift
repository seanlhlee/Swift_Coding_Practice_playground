/*:
[Previous](@previous)
______________________
# Basic Operators

An operator is a special symbol or phrase that you use to check, change, or combine values. For example, the addition operator (+) adds two numbers together (as in let i = 1 + 2). More complex examples include the logical AND operator && (as in if enteredDoorCode && passedRetinaScan) and the increment operator ++i, which is a shortcut to increase the value of i by 1.

[Overflow Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37 ""

Swift supports most standard C operators and improves several capabilities to eliminate common coding errors. The assignment operator (=) does not return a value, to prevent it from being mistakenly used when the equal to operator (==) is intended. Arithmetic operators (+, -, *, /, % and so forth) detect and disallow value overflow, to avoid unexpected results when working with numbers that become larger or smaller than the allowed value range of the type that stores them. You can opt in to value overflow behavior by using Swift’s overflow operators, as described in [Overflow Operators].

Unlike C, Swift lets you perform remainder (%) calculations on floating-point numbers. Swift also provides two range operators (a..<b and a...b) not found in C, as a shortcut for expressing a range of values.

[Advanced Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28 ""

This chapter describes the common operators in Swift. [Advanced Operators] covers Swift’s advanced operators, and describes how to define your own custom operators and implement the standard operators for your own custom types.

## Terminology

Operators are unary, binary, or ternary:

* Unary operators operate on a single target (such as -a). Unary prefix operators appear immediately before their target (such as !b), and unary postfix operators appear immediately after their target (such as i++).

* Binary operators operate on two targets (such as 2 + 3) and are infix because they appear in between their two targets.

* Ternary operators operate on three targets. Like C, Swift has only one ternary operator, the ternary conditional operator (a ? b : c).

The values that operators affect are operands. In the expression 1 + 2, the + symbol is a binary operator and its two operands are the values 1 and 2.

## Assignment Operator

The assignment operator (a = b) initializes or updates the value of a with the value of b:
*/
let b = 10
var a = 5
a = b
// a is now equal to 10
/*:
If the right side of the assignment is a tuple with multiple values, its elements can be decomposed into multiple constants or variables at once:
*/
let (x, y) = (1, 2)
// x is equal to 1, and y is equal to 2
/*:
Unlike the assignment operator in C and Objective-C, the assignment operator in Swift does not itself return a value. The following statement is not valid:
*/
//if x = y {
//	// this is not valid, because x = y does not return a value
//}
if x == y {
	// this is not valid, because x = y does not return a value
}
/*:
This feature prevents the assignment operator (=) from being used by accident when the equal to operator (==) is actually intended. By making if x = y invalid, Swift helps you to avoid these kinds of errors in your code.

## Arithmetic Operators

Swift supports the four standard arithmetic operators for all number types:

* Addition (+)

* Subtraction (-)

* Multiplication (*)

* Division (/)
*/
1 + 2       // equals 3
5 - 3       // equals 2
2 * 3       // equals 6
10.0 / 2.5  // equals 4.0
/*:

[Overflow Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID37 ""

Unlike the arithmetic operators in C and Objective-C, the Swift arithmetic operators do not allow values to overflow by default. You can opt in to value overflow behavior by using Swift’s overflow operators (such as a &+ b). See [Overflow Operators].

The addition operator is also supported for String concatenation:
*/
"hello, " + "world"  // equals "hello, world"
/*:
## Remainder Operator

The remainder operator (a % b) works out how many multiples of b will fit inside a and returns the value that is left over (known as the remainder).

**Note**

> The remainder operator (%) is also known as a modulo operator in other languages. However, its behavior in Swift for negative numbers means that it is, strictly speaking, a remainder rather than a modulo operation.

Here’s how the remainder operator works. To calculate 9 % 4, you first work out how many 4s will fit inside 9:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/remainderInteger_2x.png "")

You can fit two 4s inside 9, and the remainder is 1 (shown in orange).
*/
9 % 4    // equals 1
/*:
In Swift, this would be written as:

To determine the answer for a % b, the % operator calculates the following equation and returns remainder as its output:

a = (b x some multiplier) + remainder

where some multiplier is the largest number of multiples of b that will fit inside a.

Inserting 9 and 4 into this equation yields:

9 = (4 x 2) + 1

The same method is applied when calculating the remainder for a negative value of a:
*/
-9 % 4   // equals -1
/*:
Inserting -9 and 4 into the equation yields:

-9 = (4 x -2) + -1

giving a remainder value of -1.

The sign of b is ignored for negative values of b. This means that a % b and a % -b always give the same answer.

## Floating-Point Remainder Calculations

Unlike the remainder operator in C and Objective-C, Swift’s remainder operator can also operate on floating-point numbers:
*/
8 % 2.5   // equals 0.5
/*:
In this example, 8 divided by 2.5 equals 3, with a remainder of 0.5, so the remainder operator returns a Double value of 0.5.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/remainderFloat_2x.png "")

## Increment and Decrement Operators

Like C, Swift provides an increment operator (++) and a decrement operator (--) as a shortcut to increase or decrease the value of a numeric variable by 1. You can use these operators with variables of any integer or floating-point type.
*/
var i = 0
++i      // i now equals 1
/*:
Each time you call ++i, the value of i is increased by 1. Essentially, ++i is shorthand for saying i = i + 1. Likewise, --i can be used as shorthand for i = i - 1.

The ++ and -- symbols can be used as prefix operators or as postfix operators. ++i and i++ are both valid ways to increase the value of i by 1. Similarly, --i and i-- are both valid ways to decrease the value of i by 1.

Note that these operators modify i and also return a value. If you only want to increment or decrement the value stored in i, you can ignore the returned value. However, if you do use the returned value, it will be different based on whether you used the prefix or postfix version of the operator, according to the following rules:

* If the operator is written before the variable, it increments the variable before returning its value.

* If the operator is written after the variable, it increments the variable after returning its value.

For example:
*/
var a1 = 0
let b1 = ++a1
// a1 and b1 are now both equal to 1
let c1 = a1++
// a1 is now equal to 2, but c1 has been set to the pre-increment value of 1
/*:
In the example above, let b = ++a increments a before returning its value. This is why both a and b are equal to the new value of 1.

However, let c = a++ increments a after returning its value. This means that c gets the old value of 1, and a is then updated to equal 2.

Unless you need the specific behavior of i++, it is recommended that you use ++i and --i in all cases, because they have the typical expected behavior of modifying i and returning the result.

## Unary Minus Operator

The sign of a numeric value can be toggled using a prefixed -, known as the unary minus operator:
*/
let three = 3
let minusThree = -three       // minusThree equals -3
let plusThree = -minusThree   // plusThree equals 3, or "minus minus three"
/*:
The unary minus operator (-) is prepended directly before the value it operates on, without any white space.

## Unary Plus Operator

The unary plus operator (+) simply returns the value it operates on, without any change:
*/
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix equals -6
/*:
Although the unary plus operator doesn’t actually do anything, you can use it to provide symmetry in your code for positive numbers when also using the unary minus operator for negative numbers.

## Compound Assignment Operators

Like C, Swift provides compound assignment operators that combine assignment (=) with another operation. One example is the addition assignment operator (+=):
*/
var a2 = 1
a2 += 2
// a2 is now equal to 3
/*:
The expression a += 2 is shorthand for a = a + 2. Effectively, the addition and the assignment are combined into one operator that performs both tasks at the same time.

**Note**

> The compound assignment operators do not return a value. You cannot write let b = a += 2, for example. This behavior is different from the increment and decrement operators mentioned above.

A complete list of compound assignment operators can be found in Expressions.

## Comparison Operators

Swift supports all standard C comparison operators:

* Equal to (a == b)

* Not equal to (a != b)

* Greater than (a > b)

* Less than (a < b)

* Greater than or equal to (a >= b)

* Less than or equal to (a <= b)

**Note**

> Swift also provides two identity operators (=== and !==), which you use to test whether two object references both refer to the same object instance. For more information, see Classes and Structures.

Each of the comparison operators returns a Bool value to indicate whether or not the statement is true:
*/
1 == 1   // true, because 1 is equal to 1
2 != 1   // true, because 2 is not equal to 1
2 > 1    // true, because 2 is greater than 1
1 < 2    // true, because 1 is less than 2
1 >= 1   // true, because 1 is greater than or equal to 1
2 <= 1   // false, because 2 is not less than or equal to 1
/*:
Comparison operators are often used in conditional statements, such as the if statement:
*/
let name = "world"
if name == "world" {
	print("hello, world")
} else {
	print("I'm sorry \(name), but I don't recognize you")
}
// prints "hello, world", because name is indeed equal to "world"
/*:
[Control Flow]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120 ""

For more on the if statement, see [Control Flow].

<新版新增>
You can also compare tuples that have the same number of values, as long as each of the values in the tuple can be compared. For example, both Int and String can be compared, which means tuples of the type (Int, String) can be compared. In contrast, Bool can’t be compared, which means tuples that contain a Boolean value can’t be compared.

<新版新增>
Tuples are compared from left to right, one value at a time, until the comparison finds two values that aren’t equal. If all the elements are equal, then the tuples themselves are equal. For example:
*/
// <新版新增>
(1, "zebra") < (2, "apple")   // true because 1 is less than 2
(3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
(4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog"
/*:
<新版新增>
> The Swift standard library includes tuple comparison operators for tuples with less than seven elements. To compare tuples with seven or more elements, you must implement the comparison operators yourself.

## Ternary Conditional Operator

The ternary conditional operator is a special operator with three parts, which takes the form question ? answer1 : answer2. It is a shortcut for evaluating one of two expressions based on whether question is true or false. If question is true, it evaluates answer1 and returns its value; otherwise, it evaluates answer2 and returns its value.

The ternary conditional operator is shorthand for the code below:
*/
//if question {
//	answer1
//} else {
//	answer2
//}
/*:
Here’s an example, which calculates the height for a table row. The row height should be 50 points taller than the content height if the row has a header, and 20 points taller if the row doesn’t have a header:
*/
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
// rowHeight is equal to 90
/*:
The preceding example is shorthand for the code below:
*/
let contentHeight1 = 40
let hasHeader1 = true
var rowHeight1 = contentHeight1
if hasHeader1 {
	rowHeight1 = rowHeight1 + 50
} else {
	rowHeight1 = rowHeight1 + 20
}
// rowHeight1 is equal to 90
/*:
The first example’s use of the ternary conditional operator means that rowHeight can be set to the correct value on a single line of code. This is more concise than the second example, and removes the need for rowHeight to be a variable, because its value does not need to be modified within an if statement.

The ternary conditional operator provides an efficient shorthand for deciding which of two expressions to consider. Use the ternary conditional operator with care, however. Its conciseness can lead to hard-to-read code if overused. Avoid combining multiple instances of the ternary conditional operator into one compound statement.

## Nil Coalescing Operator

The nil coalescing operator (a ?? b) unwraps an optional a if it contains a value, or returns a default value b if a is nil. The expression a is always of an optional type. The expression b must match the type that is stored inside a.

The nil coalescing operator is shorthand for the code below:
*/
var a4: Int? , b4: Int = 3
a4 != nil ? a4! : b4
/*:
The code above uses the ternary conditional operator and forced unwrapping (a!) to access the value wrapped inside a when a is not nil, and to return b otherwise. The nil coalescing operator provides a more elegant way to encapsulate this conditional checking and unwrapping in a concise and readable form.

**Note**

> If the value of a is non-nil, the value of b is not evaluated. This is known as short-circuit evaluation.

The example below uses the nil coalescing operator to choose between a default color name and an optional user-defined color name:
*/
let defaultColorName = "red"
var userDefinedColorName: String?   // defaults to nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName is nil, so colorNameToUse is set to the default of "red"
/*:
The userDefinedColorName variable is defined as an optional String, with a default value of nil. Because userDefinedColorName is of an optional type, you can use the nil coalescing operator to consider its value. In the example above, the operator is used to determine an initial value for a String variable called colorNameToUse. Because userDefinedColorName is nil, the expression userDefinedColorName ?? defaultColorName returns the value of defaultColorName, or "red".

If you assign a non-nil value to userDefinedColorName and perform the nil coalescing operator check again, the value wrapped inside userDefinedColorName is used instead of the default:
*/
userDefinedColorName = "green"
colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName is not nil, so colorNameToUse is set to "green"
/*:
## Range Operators

Swift includes two range operators, which are shortcuts for expressing a range of values.

## Closed Range Operator

The closed range operator (a...b) defines a range that runs from a to b, and includes the values a and b. The value of a must not be greater than b.

The closed range operator is useful when iterating over a range in which you want all of the values to be used, such as with a for-in loop:
*/
for index in 1...5 {
	print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25
/*:

[Control Flow]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID120 ""

For more on for-in loops, see [Control Flow].

## Half-Open Range Operator

The half-open range operator (a..<b) defines a range that runs from a to b, but does not include b. It is said to be half-open because it contains its first value, but not its final value. As with the closed range operator, the value of a must not be greater than b. If the value of a is equal to b, then the resulting range will be empty.

Half-open ranges are particularly useful when you work with zero-based lists such as arrays, where it is useful to count up to (but not including) the length of the list:
*/
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
	print("Person \(i + 1) is called \(names[i])")
}
// Person 1 is called Anna
// Person 2 is called Alex
// Person 3 is called Brian
// Person 4 is called Jack
/*:

[Arrays]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html#//apple_ref/doc/uid/TP40014097-CH8-ID107 ""

Note that the array contains four items, but 0..<count only counts as far as 3 (the index of the last item in the array), because it is a half-open range. For more on arrays, see [Arrays].

## Logical Operators

Logical operators modify or combine the Boolean logic values true and false. Swift supports the three standard logical operators found in C-based languages:

* Logical NOT (!a)

* Logical AND (a && b)

* Logical OR (a || b)

## Logical NOT Operator

The logical NOT operator (!a) inverts a Boolean value so that true becomes false, and false becomes true.

The logical NOT operator is a prefix operator, and appears immediately before the value it operates on, without any white space. It can be read as “not a”, as seen in the following example:
*/
let allowedEntry = false
if !allowedEntry {
	print("ACCESS DENIED")
}
// prints "ACCESS DENIED"
/*:
The phrase if !allowedEntry can be read as “if not allowed entry.” The subsequent line is only executed if “not allowed entry” is true; that is, if allowedEntry is false.

As in this example, careful choice of Boolean constant and variable names can help to keep code readable and concise, while avoiding double negatives or confusing logic statements.

## Logical AND Operator

The logical AND operator (a && b) creates logical expressions where both values must be true for the overall expression to also be true.

If either value is false, the overall expression will also be false. In fact, if the first value is false, the second value won’t even be evaluated, because it can’t possibly make the overall expression equate to true. This is known as short-circuit evaluation.

This example considers two Bool values and only allows access if both values are true:
*/
let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
	print("Welcome!")
} else {
	print("ACCESS DENIED")
}
// prints "ACCESS DENIED"
/*:
## Logical OR Operator

The logical OR operator (a || b) is an infix operator made from two adjacent pipe characters. You use it to create logical expressions in which only one of the two values has to be true for the overall expression to be true.

Like the Logical AND operator above, the Logical OR operator uses short-circuit evaluation to consider its expressions. If the left side of a Logical OR expression is true, the right side is not evaluated, because it cannot change the outcome of the overall expression.

In the example below, the first Bool value (hasDoorKey) is false, but the second value (knowsOverridePassword) is true. Because one value is true, the overall expression also evaluates to true, and access is allowed:
*/
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
	print("Welcome!")
} else {
	print("ACCESS DENIED")
}
// prints "Welcome!"
/*:
## Combining Logical Operators

You can combine multiple logical operators to create longer compound expressions:
*/
if enteredDoorCode && passedRetinaScan || hasDoorKey || knowsOverridePassword {
	print("Welcome!")
} else {
	print("ACCESS DENIED")
}
// prints "Welcome!"
/*:
This example uses multiple && and || operators to create a longer compound expression. However, the && and || operators still operate on only two values, so this is actually three smaller expressions chained together. The example can be read as:

If we’ve entered the correct door code and passed the retina scan, or if we have a valid door key, or if we know the emergency override password, then allow access.

Based on the values of enteredDoorCode, passedRetinaScan, and hasDoorKey, the first two subexpressions are false. However, the emergency override password is known, so the overall compound expression still evaluates to true.

**Note**

> The Swift logical operators && and || are left-associative, meaning that compound expressions with multiple logical operators evaluate the leftmost subexpression first.

## Explicit Parentheses

It is sometimes useful to include parentheses when they are not strictly needed, to make the intention of a complex expression easier to read. In the door access example above, it is useful to add parentheses around the first part of the compound expression to make its intent explicit:
*/
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
	print("Welcome!")
} else {
	print("ACCESS DENIED")
}
// prints "Welcome!"
/*:
The parentheses make it clear that the first two values are considered as part of a separate possible state in the overall logic. The output of the compound expression doesn’t change, but the overall intention is clearer to the reader. Readability is always preferred over brevity; use parentheses where they help to make your intentions clear.
______________________
[Next](@next)
*/
