/*:
[Previous](@previous)
****
# Complex number

A complex number can be visually represented as a pair of numbers (a, b) forming a vector on a diagram called an Argand diagram, representing the complex plane. "Re" is the real axis, "Im" is the imaginary axis, and i is the imaginary unit which satisfies i² = −1.
A complex number is a number that can be expressed in the form a + bi, where a and b are real numbers and i is the imaginary unit, that satisfies the equation i² = −1. In this expression, a is the real part and b is the imaginary part of the complex number.

Complex numbers extend the concept of the one-dimensional number line to the two-dimensional complex plane by using the horizontal axis for the real part and the vertical axis for the imaginary part. The complex number a + bi can be identified with the point (a, b) in the complex plane. A complex number whose real part is zero is said to be purely imaginary, whereas a complex number whose imaginary part is zero is a real number. In this way, the complex numbers contain the ordinary real numbers while extending them in order to solve problems that cannot be solved with real numbers alone.

As well as their use within mathematics, complex numbers have practical applications in many fields, including physics, chemistry, biology, economics, electrical engineering, and statistics. The Italian mathematician Gerolamo Cardano is the first known to have introduced complex numbers. He called them "fictitious" during his attempts to find solutions to cubic equations in the 16th century.

![](1.png)

## Definition

A complex number is a number of the form a + bi, where a and b are real numbers and i is the imaginary unit, satisfying i² = −1. For example, −3.5 + 2i is a complex number.

The real number a is called the real part of the complex number a + bi; the real number b is called the imaginary part of a + bi. By this convention the imaginary part does not include the imaginary unit: hence b, not bi, is the imaginary part. The real part of a complex number z is denoted by Re(z) or ℜ(z); the imaginary part of a complex number z is denoted by Im(z) or ℑ(z). For example,

Re(-3.5 + 2i) = -3.5

Im(-3.5 + 2i) = 2

Hence, in terms of its real and imaginary parts, a complex number z is equal to Re(z) + Im(z)．i . This expression is sometimes known as the Cartesian form of z.

A real number a can be regarded as a complex number a + 0i whose imaginary part is 0. A purely imaginary number bi is a complex number 0 + bi whose real part is zero. It is common to write a for a + 0i and bi for 0 + bi. Moreover, when the imaginary part is negative, it is common to write a − bi with b > 0 instead of a + (−b)i, for example 3 − 4i instead of 3 + (−4)i.

The set of all complex numbers is denoted by ℂ, **C** or **ℂ**.

![](2.png)

An illustration of the complex plane. The real part of a complex number z = x + iy is x, and its imaginary part is y.

## Elementary operations

### Conjugate

Geometric representation of z and its conjugate \bar{z} in the complex plane
The complex conjugate of the complex number z = x + yi is defined to be x − yi. It is denoted z*.

### Addition and subtraction

![](3.png)
Addition of two complex numbers can be done geometrically by constructing a parallelogram.
Complex numbers are added by adding the real and imaginary parts of the summands. That is to say:

(a+bi) + (c+di) = (a+c) + (b+d)i
(a+bi) - (c+di) = (a-c) + (b-d)i

### Multiplication and division
The multiplication of two complex numbers is defined by the following formula:

(a+bi) (c+di) = (ac-bd) + (bc+ad)i

In particular, the square of the imaginary unit is −1:

i² = i x i = -1

The division of two complex numbers is defined in terms of complex multiplication, which is described above, and real division. When at least one of c and d is non-zero, we have

![](4.png)

### Absolute value and argument

An alternative way of defining a point P in the complex plane, other than using the x- and y-coordinates, is to use the distance of the point from O, the point whose coordinates are (0, 0), together with the angle subtended between the positive real axis and the line segment OP in a counterclockwise direction. This idea leads to the polar form of complex numbers.

The absolute value of a complex number z = x + yi is

![](5.png)

If z is a real number, then r = |x|. In general, by Pythagoras' theorem, r is the distance of the point P representing the complex number z to the origin. The square of the absolute value is

![](6.png)

where z* is the complex conjugate of z.

The argument of z is the angle of the radius OP with the positive real axis, and is written as arg(z). As with the modulus, the argument can be found from the rectangular form x+yi.

![](7.png)

### Exponentiation
Euler's formula
Euler's formula states that, for any real number x,

![](8.png)
*/
import UIKit
/*
public extension SummableMultipliable {
	public var i:Complex<Self>{
		return Complex(t: (Self(),self))
	}
	public init<U:SummableMultipliable>(_ x:U) {
		switch x {
		case let s as Self:     self.init(s)
		case let d as Double:   self.init(d)
		case let i as Int:      self.init(i)
		default:
			fatalError("init(\(x)) failed")
		}
	}
	public var isPositive: Bool {
		return self >= Self()
	}
	public func transformToInt() -> Int {
		switch self {
		case _ as Double:	return Int(self as! Double)
		case _ as Int:		return Int(self as! Int)
		default:
			fatalError("transform divider fail")
		}
	}
	public func toDouble() -> Double {
		switch self {
		case _ as Double:	return Double(self as! Double)
		case _ as Int:		return Double(self as! Int)
		default:
			fatalError("transform divider fail")
		}
	}
}

public struct Complex<T:SummableMultipliable> : Comparable, CustomStringConvertible, Hashable {
	public typealias Element = T
	public var (re, im): (T, T)
	public init(r:T, i:T) {
		self.init(t:(r, i))
	}
	public init() {
		(re, im) = (T(), T())
	}
	public init(t:(T, T)) {
		(re, im) = t
	}
	public init(abs:T, arg:T) {
		let re = abs.toDouble() * cos(arg.toDouble())
		let im = abs.toDouble() * sin(arg.toDouble())
		let z = Complex<Double>(t: (re,im))
		self.init(z)
	}
	public init<U:SummableMultipliable>(_ z:Complex<U>) {
		self.init(t:(T(z.re), T(z.im)))
	}
	public init(_ x:T) {
		(re, im) = (x, T())
	}
	public var i: Complex { return Complex(r: -im, i: re) }
	public var real:T { get{ return re } set(r){ re = r } }
	public var imag:T { get{ return im } set(i){ im = i } }
	// check the definition of norm
	public var norm:Double {
		var r, e: Double
		switch re {
		case let real as Double:
			r = real
			e = im as! Double
		case let real as Int:
			r = Double(real)
			e = Double(im as! Int)
		default:
			fatalError("init(\(re)) failed")
		}
		
		return sqrt(r*r + e*e)
	}
	public var conj:Complex { return Complex(t: (re, -im)) }
	
	public var description:String {
		let sigIm = im.isPositive ? "+\(im)" : "\(im)"
		return "(\(re)\(sigIm).i)"
	}
	public var hashValue:Int {
		return self.description.hashValue
	}
	public var tuple:(T, T) {
		get{ return (re, im) }
		set(t){ (re, im) = t }
	}
}
*/
/*:
![](9.png)
*/
/*
public extension Complex {
	public var arg:Double  {
		get { return atan2(im.toDouble(), re.toDouble()) }
	}
}

public func == <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
	return lhs.re == rhs.re && lhs.im == rhs.im
}
public func < <T>(lhs:Complex<T>, rhs:Complex<T>) -> Bool {
	return lhs.norm < rhs.norm
}

public func == <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return lhs == Complex(rhs)
}
public func == <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return Complex(lhs) == rhs
}
public func != <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return !(lhs == rhs)
}
public func != <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return !(rhs == lhs)
}
public func < <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return lhs < Complex(rhs)
}
public func < <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return Complex(lhs) < rhs
}
public func <= <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return (lhs < rhs) || (lhs == rhs)
}
public func <= <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return (lhs < rhs) || (lhs == rhs)
}
public func > <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return !(lhs < rhs) && !(lhs == rhs)
}
public func > <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return !(lhs < rhs) && !(lhs == rhs)
}
public func >= <T>(lhs:Complex<T>, rhs:T) -> Bool {
	return lhs > rhs || lhs == rhs
}
public func >= <T>(lhs:T, rhs:Complex<T>) -> Bool {
	return lhs > rhs || lhs == rhs
}
public prefix func + <T>(z:Complex<T>) -> Complex<T> {
	return z
}
public func + <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
	return Complex(t:(lhs.re + rhs.re, lhs.im + rhs.im))
}
public func + <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
	return lhs + Complex(rhs)
}
public func + <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
	return Complex(lhs) + rhs
}
public prefix func - <T>(z:Complex<T>) -> Complex<T> {
	return -z
}
public func - <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
	return Complex(t:(lhs.re - rhs.re, lhs.im - rhs.im))
}
public func - <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
	return lhs - Complex(rhs)
}
public func - <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
	return Complex(lhs) - rhs
}
public func * <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<T> {
	let r = lhs.re * rhs.re - lhs.im * rhs.im
	let i = lhs.re * rhs.im + lhs.im * rhs.re
	return Complex(t:(r, i))
}
public func * (lhs:Complex<Double>, rhs:Complex<Int>) -> Complex<Double> {
	let right = transformToDoubleComplex(rhs)
	return lhs * right
}
public func * (lhs:Complex<Int>, rhs:Complex<Double>) -> Complex<Double> {
	let left = transformToDoubleComplex(lhs)
	return left * rhs
}
public func * <T>(lhs:Complex<T>, rhs:T) -> Complex<T> {
	return lhs * Complex(rhs)
}
public func * <T>(lhs:T, rhs:Complex<T>) -> Complex<T> {
	return Complex(lhs) * rhs
}
public func += <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
	lhs = lhs + rhs
}
public func += <T>(inout lhs: Complex<T>, rhs: T) {
	lhs = lhs + rhs
}
// For type safety reason, it does not need to implement `+=` for `inout T += Complex<T>`.
// Similarly, there is no reason to implement `-=` for `inout T -= Complex<T>` and `*=` for `inout T *= Complex<T>`.
//	public func += <T>(inout lhs: T, rhs: Complex<T>) {
//		lhs = lhs + rhs
//	}
public func -= <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
	lhs = lhs - rhs
}
public func -= <T>(inout lhs: Complex<T>, rhs: T) {
	lhs = lhs - rhs
}
public func *= <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
	lhs = lhs * rhs
}
public func *= <T>(inout lhs: Complex<T>, rhs: T) {
	lhs = lhs * rhs
}
public func transformToDoubleComplex <T>(complex: Complex<T>) -> Complex<Double> {
	return Complex(t: (complex.re.toDouble(), complex.im.toDouble()))
}
public func / <T>(lhs:Complex<T>, rhs:T) -> Complex<Double> {
	guard rhs != T() else { fatalError("division by zero") }
	return transformToDoubleComplex(lhs) * (1 / rhs.toDouble())
}
public func / <T>(lhs:Complex<T>, rhs:Complex<T>) -> Complex<Double> {
	guard rhs.norm != 0 else { fatalError("division by zero") }
	let left = transformToDoubleComplex(lhs)
	let right = transformToDoubleComplex(rhs)
	return left * right.conj / right.norm / right.norm
}
public func / <T>(lhs:T, rhs:Complex<T>) -> Complex<Double> {
	guard rhs.norm != 0 else { fatalError("division by zero") }
	return Complex(lhs) / rhs
}
public func /= <T:SummableMultipliable>(inout lhs: Complex<Double>, rhs: T) {
	let right: Double = rhs.toDouble()
	lhs = lhs / right
}
public func /= <T>(inout lhs: Complex<Double>, rhs: Complex<T>) {
	let right = transformToDoubleComplex(rhs)
	lhs = lhs / right
}
public func exp<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let r = exp(z.re.toDouble())
	let a = z.im.toDouble()
	return Complex(t:(r * cos(a), r * sin(a)))
}
public func log<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return Complex(t:(log(z.norm), z.arg.toDouble()))
}
public func log10<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return log(z) / M_LN10
}

public func pow<T:SummableMultipliable>(lhs:Complex<T>, _ rhs:Complex<T>) -> Complex<Double> {
	let right = transformToDoubleComplex(rhs)
	return exp(log(lhs) * right)
}
public func pow<T:SummableMultipliable>(lhs:Complex<T>, _ rhs: T) -> Complex<Double> {
	let right = Complex(rhs.toDouble())
	return exp(log(lhs) * right)
}
*/
/*:
![](10.png)
*/
/*
public func sqrt<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	// return z ** 0.5
	let r = sqrt(z.norm)
	let theta = z.arg/2
	let re = r * cos(theta)
	let im = r * sin(theta)
	return Complex<Double>(t: (re,im))
}
public func cos<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let re = cos(z.re.toDouble()) * cosh(z.im.toDouble())
	let im = -sin(z.re.toDouble()) * sinh(z.im.toDouble())
	return Complex<Double>(t:(re,im))
}
public func sin<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let re = sin(z.re.toDouble()) * cosh(z.im.toDouble())
	let im = cos(z.re.toDouble()) * sinh(z.im.toDouble())
	return Complex<Double>(t:(re,im))
}
public func tan<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return sin(z) / cos(z)
}
*/
/*:
![](11.png)
*/
/*
public func atan<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return (1/2.0.i) * log((1.0.i-transformToDoubleComplex(z))/(1.0.i+transformToDoubleComplex(z)) )
}
public func asin<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let zx = transformToDoubleComplex(z)
	return (0.0-1.0.i) * log( zx.i + sqrt(1.0 - (zx * zx)))
}
public func acos<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let zx = transformToDoubleComplex(z)
	return log(zx - sqrt(1.0 - zx * zx).i).i
}
public func sinh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let zx = transformToDoubleComplex(z)
	return -1 * sin(zx.i).i
}
public func cosh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return cos(z.i)
}
public func tanh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return sinh(z) / cosh(z)
}
public func asinh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let zx = transformToDoubleComplex(z)
	return log(zx + sqrt(zx*zx + 1.0))
}
public func acosh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	let zx = transformToDoubleComplex(z)
	return log(zx + sqrt(zx*zx - 1.0))
}
public func atanh<T:SummableMultipliable>(z:Complex<T>) -> Complex<Double> {
	return (1.0/2.0) * log((1.0 + transformToDoubleComplex(z)) / (1.0 - transformToDoubleComplex(z)))
}

*/


var z1 = 3 + 4.i
z1.re
z1.im
z1.norm
z1.arg
z1.conj
z1.i
2 * z1
z1 * 2
z1 / 2
var z2 = 2 + 0.i
z1 * z2
z2 * z1
z1 / z2
z1 == z2
z1 > z2
z1 >= z2
z1 < z2
z1 <= z2

var z3 = 3.0 + 4.i
z3.re
z3.im
z3.norm
z3.arg
z3.conj
z3.i
2 * z3
z3 * 2
z3 / 2
var z4 = 2.0 + 0.i
z3 * z4
z4 * z3
z3 / z4
z3 == z4
z3 > z4
z3 >= z4
z3 < z4
z3 <= z4

sqrt(z1)
sqrt(z3)
z1 * z1
sqrt(-7 + 24.i)
sqrt(-7.0 + 24.i)
exp(z1)
exp(z3)
exp(log(z3))
log(z1)
log(z3)
log(exp(z3))
log10(z1)
log10(z3)
pow(10.0 + 0.i,log10(z1))
pow(10.0 + 0.i,log10(z3))
sin(z3)
asin(z3)
asin(sin(z3))
sin(asin(z3))
cos(z3)
acos(z3)
acos(cos(z3))
cos(acos(z3))
tan(z3)
atan(z3)
atan(tan(z3))
tan(atan(z3))

sinh(z3)
asinh(z3)
asinh(sinh(z3))
sinh(asinh(z3))
cosh(z3)
acosh(z3)
acosh(cosh(z3))
cosh(acosh(z3))
tanh(z3)
atanh(z3)
atanh(tanh(z3))
tanh(atanh(z3))


var abc: Int8 = 16
abc.toComplex()
var abcd = 17
abcd.i
abcd.toComplex()
/*:
****
[Next](@next)
*/
