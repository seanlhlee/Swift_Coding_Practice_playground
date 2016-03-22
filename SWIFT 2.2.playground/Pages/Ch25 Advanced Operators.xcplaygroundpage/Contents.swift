/*:
[Previous](@previous)
______________________
[Basic Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID60 ""

# Advanced Operators

In addition to the operators described in [Basic Operators], Swift provides several advanced operators that perform more complex value manipulation. These include all of the bitwise and bit shifting operators you will be familiar with from C and Objective-C.

Unlike arithmetic operators in C, arithmetic operators in Swift do not overflow by default. Overflow behavior is trapped and reported as an error. To opt in to overflow behavior, use Swift’s second set of arithmetic operators that overflow by default, such as the overflow addition operator (&+). All of these overflow operators begin with an ampersand (&).

When you define your own structures, classes, and enumerations, it can be useful to provide your own implementations of the standard Swift operators for these custom types. Swift makes it easy to provide tailored implementations of these operators and to determine exactly what their behavior should be for each type you create.

You’re not limited to the predefined operators. Swift gives you the freedom to define your own custom infix, prefix, postfix, and assignment operators, with custom precedence and associativity values. These operators can be used and adopted in your code like any of the predefined operators, and you can even extend existing types to support the custom operators you define.

## Bitwise Operators

Bitwise operators enable you to manipulate the individual raw data bits within a data structure. They are often used in low-level programming, such as graphics programming and device driver creation. Bitwise operators can also be useful when you work with raw data from external sources, such as encoding and decoding data for communication over a custom protocol.

Swift supports all of the bitwise operators found in C, as described below.

### Bitwise NOT Operator

The bitwise NOT operator (~) inverts all bits in a number:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitwiseNOT_2x.png "")

The bitwise NOT operator is a prefix operator, and appears immediately before the value it operates on, without any white space:
*/
let initialBits: UInt8 = 0b00001111
var invertedBits = ~initialBits  // equals 11110000
String(invertedBits, radix: 2)  //顯示記憶體中invertedBits的2進位形式

/// 以下用以顯示2進位形式
protocol BitFormRepresentable { func toInt() -> Int }

extension UInt: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension Int8: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension UInt8: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension Int16: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension UInt16: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension Int32: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension UInt32: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension Int64: BitFormRepresentable { func toInt() -> Int { return Int(self) } }
extension UInt64: BitFormRepresentable { func toInt() -> Int { return Int(self) } }

extension BitFormRepresentable {
	var bitRep: String {
		var size: Int
		switch self {
		case is Int8, is UInt8: size = 7
		case is Int16, is UInt16: size = 15
		case is Int32, is UInt32: size = 31
		case is Int64, is UInt64: size = 63
		default : size = 63
		}
		let n = self.toInt()
		var rep = ""
//		for (var c = size; c >= 0; c--) {
		for c in -size...0 {
			let k = n >> -c
			if (k & 1) == 1 { rep += "1" } else { rep += "0" }
			if -c%8  == 0 && -c != 0 { rep += " " }
		}
		return rep
	}
	var hexRep: String {
		let size: Int = {
			switch self {
			case is Int8, is UInt8: return 1
			case is Int16, is UInt16: return 3
			case is Int32, is UInt32: return 7
			case is Int64, is UInt64: return 15
			default : return 15
			}
		}()
		var n = self.toInt()
		var rep = ""
		var reverse = [Character]()
		for _ in 0...size {
			let k: Character = {
				let x = n % 16
				switch x {
				case 0...9:
					return x.description.characters.last!
				case 10:
					return "A"
				case 11:
					return "B"
				case 12:
					return "C"
				case 13:
					return "D"
				case 14:
					return "E"
				case 15:
					return "F"
				default:
					return "0"
				}
			}()
			n = n / 16
			reverse.append(k)
		}
		for i in 0..<reverse.count {
			rep.append(reverse[reverse.count - i - 1])
		}
		return rep
	}
}
invertedBits.bitRep
/*:
UInt8 integers have eight bits and can store any value between 0 and 255. This example initializes a UInt8 integer with the binary value 00001111, which has its first four bits set to 0, and its second four bits set to 1. This is equivalent to a decimal value of 15.

The bitwise NOT operator is then used to create a new constant called invertedBits, which is equal to initialBits, but with all of the bits inverted. Zeros become ones, and ones become zeros. The value of invertedBits is 11110000, which is equal to an unsigned decimal value of 240.

### Bitwise AND Operator

The bitwise AND operator (&) combines the bits of two numbers. It returns a new number whose bits are set to 1 only if the bits were equal to 1 in both input numbers:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitwiseAND_2x.png "")

In the example below, the values of firstSixBits and lastSixBits both have four middle bits equal to 1. The bitwise AND operator combines them to make the number 00111100, which is equal to an unsigned decimal value of 60:
*/
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8  = 0b00111111
var middleFourBits = firstSixBits & lastSixBits  // equals 00111100
middleFourBits.bitRep
/*:
### Bitwise OR Operator

The bitwise OR operator (|) compares the bits of two numbers. The operator returns a new number whose bits are set to 1 if the bits are equal to 1 in either input number:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitwiseOR_2x.png "")

In the example below, the values of someBits and moreBits have different bits set to 1. The bitwise OR operator combines them to make the number 11111110, which equals an unsigned decimal of 254:
*/
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedbits = someBits | moreBits  // equals 11111110
combinedbits.bitRep
/*:
### Bitwise XOR Operator

The bitwise XOR operator, or “exclusive OR operator” (^), compares the bits of two numbers. The operator returns a new number whose bits are set to 1 where the input bits are different and are set to 0 where the input bits are the same:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitwiseXOR_2x.png "")

In the example below, the values of firstBits and otherBits each have a bit set to 1 in a location that the other does not. The bitwise XOR operator sets both of these bits to 1 in its output value. All of the other bits in firstBits and otherBits match and are set to 0 in the output value:
*/
let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits  // equals 00010001
outputBits.bitRep
/*:
### Bitwise Left and Right Shift Operators

The bitwise left shift operator (<<) and bitwise right shift operator (>>) move all bits in a number to the left or the right by a certain number of places, according to the rules defined below.

Bitwise left and right shifts have the effect of multiplying or dividing an integer number by a factor of two. Shifting an integer’s bits to the left by one position doubles its value, whereas shifting it to the right by one position halves its value.

#### Shifting Behavior for Unsigned Integers

The bit-shifting behavior for unsigned integers is as follows:

1. Existing bits are moved to the left or right by the requested number of places.

2. Any bits that are moved beyond the bounds of the integer’s storage are discarded.

3. Zeros are inserted in the spaces left behind after the original bits are moved to the left or right.

This approach is known as a logical shift.

The illustration below shows the results of 11111111 << 1 (which is 11111111 shifted to the left by 1 place), and 11111111 >> 1 (which is 11111111 shifted to the right by 1 place). Blue numbers are shifted, gray numbers are discarded, and orange zeros are inserted:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftUnsigned_2x.png "")

Here’s how bit shifting looks in Swift code:
*/
let shiftBits: UInt8 = 4   // 00000100 in binary
shiftBits.bitRep
let l1 = shiftBits << 1             // 00001000
l1.bitRep
let l2 = shiftBits << 2             // 00010000
l2.bitRep
let l5 = shiftBits << 5             // 10000000
l5.bitRep
let l6 = shiftBits << 6             // 00000000
l6.bitRep
let r2 = shiftBits >> 2             // 00000001
r2.bitRep
/*:
You can use bit shifting to encode and decode values within other data types:
*/
let pink: UInt32 = 0xCC6699
pink.hexRep
let redComponent = (pink & 0xFF0000) >> 16    // redComponent is 0xCC, or 204
redComponent.hexRep
let greenComponent = (pink & 0x00FF00) >> 8   // greenComponent is 0x66, or 102
greenComponent.hexRep
let blueComponent = pink & 0x0000FF           // blueComponent is 0x99, or 153
blueComponent.hexRep


let a: Int32 = 0xCC6699
let b: Int32 = 0xFF0000
a.bitRep
b.bitRep

let and = (a & b).hexRep
let or = (a | b).hexRep
let xor = (a ^ b).hexRep
let c: Int32 = 0b001100110110011010011001
c.hexRep

/*:
This example uses a UInt32 constant called pink to store a Cascading Style Sheets color value for the color pink. The CSS color value #CC6699 is written as 0xCC6699 in Swift’s hexadecimal number representation. This color is then decomposed into its red (CC), green (66), and blue (99) components by the bitwise AND operator (&) and the bitwise right shift operator (>>).

The red component is obtained by performing a bitwise AND between the numbers 0xCC6699 and 0xFF0000. The zeros in 0xFF0000 effectively “mask” the second and third bytes of 0xCC6699, causing the 6699 to be ignored and leaving 0xCC0000 as the result.

This number is then shifted 16 places to the right (>> 16). Each pair of characters in a hexadecimal number uses 8 bits, so a move 16 places to the right will convert 0xCC0000 into 0x0000CC. This is the same as 0xCC, which has a decimal value of 204.

Similarly, the green component is obtained by performing a bitwise AND between the numbers 0xCC6699 and 0x00FF00, which gives an output value of 0x006600. This output value is then shifted eight places to the right, giving a value of 0x66, which has a decimal value of 102.

Finally, the blue component is obtained by performing a bitwise AND between the numbers 0xCC6699 and 0x0000FF, which gives an output value of 0x000099. There’s no need to shift this to the right, as 0x000099 already equals 0x99, which has a decimal value of 153.

#### Shifting Behavior for Signed Integers

The shifting behavior is more complex for signed integers than for unsigned integers, because of the way signed integers are represented in binary. (The examples below are based on 8-bit signed integers for simplicity, but the same principles apply for signed integers of any size.)

Signed integers use their first bit (known as the sign bit) to indicate whether the integer is positive or negative. A sign bit of 0 means positive, and a sign bit of 1 means negative.

The remaining bits (known as the value bits) store the actual value. Positive numbers are stored in exactly the same way as for unsigned integers, counting upwards from 0. Here’s how the bits inside an Int8 look for the number 4:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftSignedFour_2x.png "")

The sign bit is 0 (meaning “positive”), and the seven value bits are just the number 4, written in binary notation.

Negative numbers, however, are stored differently. They are stored by subtracting their absolute value from 2 to the power of n, where n is the number of value bits. An eight-bit number has seven value bits, so this means 2 to the power of 7, or 128.

Here’s how the bits inside an Int8 look for the number -4:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftSignedMinusFour_2x.png "")

This time, the sign bit is 1 (meaning “negative”), and the seven value bits have a binary value of 124 (which is 128 - 4):

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftSignedMinusFourValue_2x.png "")

The encoding for negative numbers is known as a two’s complement representation. It may seem an unusual way to represent negative numbers, but it has several advantages.

First, you can add -1 to -4, simply by performing a standard binary addition of all eight bits (including the sign bit), and discarding anything that doesn’t fit in the eight bits once you’re done:

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftSignedAddition_2x.png "")
Second, the two’s complement representation also lets you shift the bits of negative numbers to the left and right like positive numbers, and still end up doubling them for every shift you make to the left, or halving them for every shift you make to the right. To achieve this, an extra rule is used when signed integers are shifted to the right:

* When you shift signed integers to the right, apply the same rules as for unsigned integers, but fill any empty bits on the left with the sign bit, rather than with a zero.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/bitshiftSigned_2x.png "")

This action ensures that signed integers have the same sign after they are shifted to the right, and is known as an arithmetic shift.

Because of the special way that positive and negative numbers are stored, shifting either of them to the right moves them closer to zero. Keeping the sign bit the same during this shift means that negative integers remain negative as their value moves closer to zero.

## Overflow Operators

If you try to insert a number into an integer constant or variable that cannot hold that value, by default Swift reports an error rather than allowing an invalid value to be created. This behavior gives extra safety when you work with numbers that are too large or too small.

For example, the Int16 integer type can hold any signed integer number between -32768 and 32767. Trying to set an Int16 constant or variable to a number outside of this range causes an error:
*/
var potentialOverflow = Int16.max
// potentialOverflow equals 32767, which is the maximum value an Int16 can hold
//potentialOverflow += 1
// this causes an error
potentialOverflow &+ 1
/*:
Providing error handling when values get too large or too small gives you much more flexibility when coding for boundary value conditions.

However, when you specifically want an overflow condition to truncate the number of available bits, you can opt in to this behavior rather than triggering an error. Swift provides three arithmetic overflow operators that opt in to the overflow behavior for integer calculations. These operators all begin with an ampersand (&):

* Overflow addition (&+)

* Overflow subtraction (&-)

* Overflow multiplication (&*)

### Value Overflow

Numbers can overflow in both the positive and negative direction.

Here’s an example of what happens when an unsigned integer is allowed to overflow in the positive direction, using the overflow addition operator (&+):
*/
var unsignedOverflow = UInt8.max
// unsignedOverflow equals 255, which is the maximum value a UInt8 can hold
unsignedOverflow = unsignedOverflow &+ 1
// unsignedOverflow is now equal to 0
/*:
The variable unsignedOverflow is initialized with the maximum value a UInt8 can hold (255, or 11111111 in binary). It is then incremented by 1 using the overflow addition operator (&+). This pushes its binary representation just over the size that a UInt8 can hold, causing it to overflow beyond its bounds, as shown in the diagram below. The value that remains within the bounds of the UInt8 after the overflow addition is 00000000, or zero.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/overflowAddition_2x.png "")

Something similar happens when an unsigned integer is allowed to overflow in the negative direction. Here’s an example using the overflow subtraction operator (&-):
*/
var unsignedOverflow_ = UInt8.min
// unsignedOverflow equals 0, which is the minimum value a UInt8 can hold
unsignedOverflow_ = unsignedOverflow_ &- 1
// unsignedOverflow is now equal to 255
/*:
The minimum value that a UInt8 can hold is zero, or 00000000 in binary. If you subtract 1 from 00000000 using the overflow subtraction operator (&-), the number will overflow and wrap around to 11111111, or 255 in decimal.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/overflowUnsignedSubtraction_2x.png "")

[Bitwise Left and Right Shift Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID34 ""

Overflow also occurs for signed integers. All addition and subtraction for signed integers is performed in bitwise fashion, with the sign bit included as part of the numbers being added or subtracted, as described in [Bitwise Left and Right Shift Operators].
*/
var signedOverflow = Int8.min
// signedOverflow equals -128, which is the minimum value an Int8 can hold
signedOverflow = signedOverflow &- 1
// signedOverflow is now equal to 127
/*:
The minimum value that an Int8 can hold is -128, or 10000000 in binary. Subtracting 1 from this binary number with the overflow operator gives a binary value of 01111111, which toggles the sign bit and gives positive 127, the maximum positive value that an Int8 can hold.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/overflowSignedSubtraction_2x.png "")

For both signed and unsigned integers, overflow in the positive direction wraps around from the maximum valid integer value back to the minimum, and overflow in the negative direction wraps around from the minimum value to the maximum.

## Precedence and Associativity

Operator precedence gives some operators higher priority than others; these operators are applied first.

Operator associativity defines how operators of the same precedence are grouped together—either grouped from the left, or grouped from the right. Think of it as meaning “they associate with the expression to their left,” or “they associate with the expression to their right.”

It is important to consider each operator’s precedence and associativity when working out the order in which a compound expression will be calculated. For example, operator precedence explains why the following expression equals 17.
*/
2 + 3 % 4 * 5
// this equals 17
2 + 5 * 3 % 4
// Remainder and multiplication both associate with the expression to their left.

/*:
If you read strictly from left to right, you might expect the expression to be calculated as follows:

* 2 plus 3 equals 5

* 5 remainder 4 equals 1

* 1 times 5 equals 5

However, the actual answer is 17, not 5. Higher-precedence operators are evaluated before lower-precedence ones. In Swift, as in C, the remainder operator (%) and the multiplication operator (*) have a higher precedence than the addition operator (+). As a result, they are both evaluated before the addition is considered.

However, remainder and multiplication have the same precedence as each other. To work out the exact evaluation order to use, you also need to consider their associativity. Remainder and multiplication both associate with the expression to their left. Think of this as adding implicit parentheses around these parts of the expression, starting from their left:
*/
2 + ((3 % 4) * 5)
/*:
(3 % 4) is 3, so this is equivalent to:
*/
2 + (3 * 5)
/*:
(3 * 5) is 15, so this is equivalent to:
*/
2 + 15
/*:
This calculation yields the final answer of 17.

[Expressions]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Expressions.html#//apple_ref/doc/uid/TP40014097-CH32-ID383 ""
[Swift Standard Library Operators Reference]:https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Operators/index.html#//apple_ref/doc/uid/TP40016054 ""

For a complete list of Swift operator precedences and associativity rules, see [Expressions]. For information about the operators provided by the Swift standard library, see [Swift Standard Library Operators Reference].

**Note**

> Swift’s operator precedences and associativity rules are simpler and more predictable than those found in C and Objective-C. However, this means that they are not exactly the same as in C-based languages. Be careful to ensure that operator interactions still behave in the way you intend when porting existing code to Swift.

## Operator Functions

Classes and structures can provide their own implementations of existing operators. This is known as overloading the existing operators.

The example below shows how to implement the arithmetic addition operator (+) for a custom structure. The arithmetic addition operator is a binary operator because it operates on two targets and is said to be infix because it appears in between those two targets.

The example defines a Vector2D structure for a two-dimensional position vector (x, y), followed by a definition of an operator function to add together instances of the Vector2D structure:
*/
struct Vector2D {
	var x = 0.0, y = 0.0
}
func + (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(x: left.x + right.x, y: left.y + right.y)
}
/*:
The operator function is defined as a global function with a function name that matches the operator to be overloaded (+). Because the arithmetic addition operator is a binary operator, this operator function takes two input parameters of type Vector2D and returns a single output value, also of type Vector2D.

In this implementation, the input parameters are named left and right to represent the Vector2D instances that will be on the left side and right side of the + operator. The function returns a new Vector2D instance, whose x and y properties are initialized with the sum of the x and y properties from the two Vector2D instances that are added together.

The function is defined globally, rather than as a method on the Vector2D structure, so that it can be used as an infix operator between existing Vector2D instances:
*/
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
// combinedVector is a Vector2D instance with values of (5.0, 5.0)
/*:
This example adds together the vectors (3.0, 1.0) and (2.0, 4.0) to make the vector (5.0, 5.0), as illustrated below.

![](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Art/vectorAddition_2x.png "")

### Prefix and Postfix Operators

The example shown above demonstrates a custom implementation of a binary infix operator. Classes and structures can also provide implementations of the standard unary operators. Unary operators operate on a single target. They are prefix if they precede their target (such as -a) and postfix operators if they follow their target (such as i++).

You implement a prefix or postfix unary operator by writing the prefix or postfix modifier before the func keyword when declaring the operator function:
*/
prefix func - (vector: Vector2D) -> Vector2D {
	return Vector2D(x: -vector.x, y: -vector.y)
}
/*:
The example above implements the unary minus operator (-a) for Vector2D instances. The unary minus operator is a prefix operator, and so this function has to be qualified with the prefix modifier.

For simple numeric values, the unary minus operator converts positive numbers into their negative equivalent and vice versa. The corresponding implementation for Vector2D instances performs this operation on both the x and y properties:
*/
let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
// negative is a Vector2D instance with values of (-3.0, -4.0)
let alsoPositive = -negative
// alsoPositive is a Vector2D instance with values of (3.0, 4.0)
/*:
## Compound Assignment Operators

Compound assignment operators combine assignment (=) with another operation. For example, the addition assignment operator (+=) combines addition and assignment into a single operation. You mark a compound assignment operator’s left input parameter as inout, because the parameter’s value will be modified directly from within the operator function.

The example below implements an addition assignment operator function for Vector2D instances:
*/
func += (inout left: Vector2D, right: Vector2D) {
	left = left + right
}
/*:
Because an addition operator was defined earlier, you don’t need to reimplement the addition process here. Instead, the addition assignment operator function takes advantage of the existing addition operator function, and uses it to set the left value to be the left value plus the right value:
*/
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
// original now has values of (4.0, 6.0)
/*:
You can combine assignment with either the prefix or postfix modifier, as in this implementation of the prefix increment operator (++a) for Vector2D instances:
*/
prefix func ++ (inout vector: Vector2D) -> Vector2D {
	vector += Vector2D(x: 1.0, y: 1.0)
	return vector
}
/*:
The prefix increment operator function above takes advantage of the addition assignment operator defined earlier. It adds a Vector2D with x and y values of 1.0 to the Vector2D on which it is called, and returns the result:
*/
var toIncrement = Vector2D(x: 3.0, y: 4.0)
let afterIncrement = ++toIncrement
// toIncrement now has values of (4.0, 5.0)
// afterIncrement also has values of (4.0, 5.0)
/*:
**Note**

> It is not possible to overload the default assignment operator (=). Only the compound assignment operators can be overloaded. Similarly, the ternary conditional operator (a ? b : c) cannot be overloaded.

### Equivalence Operators

Custom classes and structures do not receive a default implementation of the equivalence operators, known as the “equal to” operator (==) and “not equal to” operator (!=). It is not possible for Swift to guess what would qualify as “equal” for your own custom types, because the meaning of “equal” depends on the roles that those types play in your code.

To use the equivalence operators to check for equivalence of your own custom type, provide an implementation of the operators in the same way as for other infix operators:
*/
func == (left: Vector2D, right: Vector2D) -> Bool {
	return (left.x == right.x) && (left.y == right.y)
}
func != (left: Vector2D, right: Vector2D) -> Bool {
	return !(left == right)
}
/*:
The above example implements an “equal to” operator (==) to check if two Vector2D instances have equivalent values. In the context of Vector2D, it makes sense to consider “equal” as meaning “both instances have the same x values and y values”, and so this is the logic used by the operator implementation. The example also implements the “not equal to” operator (!=), which simply returns the inverse of the result of the “equal to” operator.

You can now use these operators to check whether two Vector2D instances are equivalent:
*/
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
	print("These two vectors are equivalent.")
}
// prints "These two vectors are equivalent."
/*:
[Operators]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID418 ""

## Custom Operators

You can declare and implement your own custom operators in addition to the standard operators provided by Swift. For a list of characters that can be used to define custom operators, see [Operators].

New operators are declared at a global level using the operator keyword, and are marked with the prefix, infix or postfix modifiers:
*/
prefix operator +++ {}
/*:
The example above defines a new prefix operator called +++. This operator does not have an existing meaning in Swift, and so it is given its own custom meaning below in the specific context of working with Vector2D instances. For the purposes of this example, +++ is treated as a new “prefix doubling incrementer” operator. It doubles the x and y values of a Vector2D instance, by adding the vector to itself with the addition assignment operator defined earlier:
*/
prefix func +++ (inout vector: Vector2D) -> Vector2D {
	vector += vector
	return vector
}
/*:
This implementation of +++ is very similar to the implementation of ++ for Vector2D, except that this operator function adds the vector to itself, rather than adding Vector2D(1.0, 1.0):
*/
var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
// toBeDoubled now has values of (2.0, 8.0)
// afterDoubling also has values of (2.0, 8.0)
/*:
[Precedence and Associativity]:https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID41 ""

### Precedence and Associativity for Custom Infix Operators

Custom infix operators can also specify a precedence and an associativity. See [Precedence and Associativity] for an explanation of how these two characteristics affect an infix operator’s interaction with other infix operators.

The possible values for associativity are left, right, and none. Left-associative operators associate to the left if written next to other left-associative operators of the same precedence. Similarly, right-associative operators associate to the right if written next to other right-associative operators of the same precedence. Non-associative operators cannot be written next to other operators with the same precedence.

The associativity value defaults to none if it is not specified. The precedence value defaults to 100 if it is not specified.

The following example defines a new custom infix operator called +-, with left associativity and a precedence of 140:
*/
infix operator +- { associativity left precedence 140 }
func +- (left: Vector2D, right: Vector2D) -> Vector2D {
	return Vector2D(x: left.x + right.x, y: left.y - right.y)
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// plusMinusVector is a Vector2D instance with values of (4.0, -2.0)

/*:
[Swift Standard Library Operators Reference]:https://developer.apple.com/library/ios/documentation/Swift/Reference/Swift_StandardLibrary_Operators/index.html#//apple_ref/doc/uid/TP40016054 ""

This operator adds together the x values of two vectors, and subtracts the y value of the second vector from the first. Because it is in essence an “additive” operator, it has been given the same associativity and precedence values (left and 140) as default additive infix operators such as + and -. For a complete list of the operator precedence and associativity settings, for the operators provided by the Swift standard library, see [Swift Standard Library Operators Reference].

**Note**

> You do not specify a precedence when defining a prefix or postfix operator. However, if you apply both a prefix and a postfix operator to the same operand, the postfix operator is applied first.
______________________
[Next](@next)
*/
//以下為練習, 顏色的數學實際上不是這樣的

import UIKit

// Custom Operators
infix operator ** { associativity left precedence 160 }
func ** (left: Double, right: Double) -> Double {
	return pow(left, right)
}

2 ** 3 // 8

// When creating custom operators, make sure to also create the corresponding assignment operator, if appropriate:

infix operator **= { associativity right precedence 90 }
func **= (inout left: Double, right: Double) {
	left = left ** right
}

// Use of Mathematical Symbols
prefix operator √ {}
prefix func √ (number: Double) -> Double {
	return sqrt(number)
}
√16
√2

infix operator ± { associativity left precedence 140 }
func ± (left: Double, right: Double) -> (Double, Double) {
	return (left + right, left - right)
}

prefix operator ± {}
prefix func ± (value: Double) -> (Double, Double) {
	return 0 ± value
}

2 ± 3
±4




func == (left: UIColor, right: UIColor) -> Bool {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	left.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	right.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
	return rl == rr && gl == gr && bl == br && al == ar
}

let white1 = UIColor.whiteColor()
let white2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
white1 == white2
let gray1 = UIColor.grayColor()
gray1 == white1

func + (left: UIColor, right: UIColor) -> UIColor {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	left.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	right.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
	let r = (rl + rr) / 2, g = (gl + gr) / 2, b = (bl + br) / 2, a = (al + ar) / 2
	return UIColor(red: r, green: g, blue: b, alpha: a)
}
white1 + gray1
let blue = UIColor.blueColor()
let red = UIColor.redColor()
let green = UIColor.greenColor()
let purple1 = UIColor.purpleColor()
let purple2 = blue + red
purple1 == purple2

func - (left: UIColor, right: UIColor) -> UIColor {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	left.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	right.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
	let r = (rl - rr) / 2, g = (gl - gr) / 2, b = (bl - br) / 2, a = max((al - ar) / 2, (al + ar) / 2)
	return UIColor(red: r, green: g, blue: b, alpha: a)
}

let purple3 = white1 - green
purple2 == purple3
let yellow = UIColor.yellowColor()
yellow - green
green + red
blue + yellow
red + yellow
(red + yellow) - red
green + blue
red + green + blue


