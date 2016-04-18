import UIKit

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

