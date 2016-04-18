import Foundation
public protocol VectorType {
	associatedtype Vector
	init?(fromArray: [Double])
	var isZeroVector: Bool { get }
	var unitVector: Vector { get }
	var arrayForm: [Double] { get set }
	func == (lhs: Vector, rhs: Vector) -> Bool
}

public struct Vector2D: VectorType, Equatable, CustomStringConvertible {
	public static var zeroVector: Vector2D {
		return Vector2D(x: 0.0, y: 0.0)
	}
	public typealias Vector = Vector2D
	var x = 0.0, y = 0.0
	public init() {
		
	}
	public init(x: Double, y:Double ) {
		self.x = x
		self.y = y
	}
	public init?(fromArray array: [Double]) {
		guard array.count == 2 else { return }
		self.x = array[0]
		self.y = array[1]
	}
	public var arrayForm: [Double] {
		get {
			return [x, y]
		}
		set {
			guard newValue.count == 2 else { return }
			self.dynamicType.init(fromArray: newValue)
		}
	}
	var length: Double {
		return sqrt(arrayForm.map{ $0 * $0 }.reduce(0){ $0 + $1 })
	}
	var theta: Double {
		return atan2(y, x)
	}
	public var isZeroVector: Bool {
		if x == 0.0 && y == 0.0 {
			return true
		}
		return false
	}
	public var unitVector: Vector2D {
		guard !isZeroVector else { return Vector2D() }
		let array = self.arrayForm.map{ $0 / length}
		return Vector2D(fromArray: array)!
	}
	public var description: String {
		return "x: \(x), y: \(y)"
	}
	public var polar: String {
		return "(r: \(length), 𝛉: \(theta))"
	}
}
public struct Vector3D: VectorType, Equatable, CustomStringConvertible {
	public static var zeroVector: Vector3D {
		return Vector3D(x: 0.0, y: 0.0, z: 0.0)
	}
	public typealias Vector = Vector3D
	var x = 0.0, y = 0.0, z = 0.0
	public init() {
		
	}
	public init(x: Double, y:Double, z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}
	public init?(fromArray array: [Double]) {
		guard array.count == 3 else { return }
		self.x = array[0]
		self.y = array[1]
		self.z = array[2]
	}
	public var arrayForm: [Double] {
		get {
			return [x, y, z]
		}
		set {
			guard newValue.count == 3 else { return }
			self.dynamicType.init(fromArray: newValue)
		}
	}
	var length: Double {
		return sqrt(arrayForm.map{ $0 * $0 }.reduce(0){ $0 + $1 })
	}
	public var isZeroVector: Bool {
		if x == 0.0 && y == 0.0 && z == 0.0 {
			return true
		}
		return false
	}
	public var unitVector: Vector3D {
		guard !isZeroVector else { return Vector3D() }
		let array = self.arrayForm.map{ $0 / length}
		return Vector3D(fromArray: array)!
	}
	public var description: String {
		return "x: \(x), y: \(y), z: \(z)"
	}
}

public func == <T: VectorType>(lhs: T, rhs: T) -> Bool {
	return lhs.arrayForm == rhs.arrayForm
}
public func != <T: VectorType>(lhs: T, rhs: T) -> Bool {
	return !(lhs == rhs)
}

public func + <T: VectorType>(lhs: T, rhs: T) -> T {
	var array = [Double]()
	for i in 0..<lhs.arrayForm.count {
		array.append(lhs.arrayForm[i] + rhs.arrayForm[i])
	}
	return T.init(fromArray: array)!
}
public prefix func - <T: VectorType>(vector: T) -> T {
	let array = vector.arrayForm.map{ -$0 }
	return T.init(fromArray: array)!
}
public func - <T: VectorType>(lhs: T, rhs: T) -> T {
	var array = [Double]()
	for i in 0..<lhs.arrayForm.count {
		array.append(lhs.arrayForm[i] - rhs.arrayForm[i])
	}
	return T.init(fromArray: array)!
}
public func += <T: VectorType>(inout lhs: T, rhs: T) {
	lhs = lhs + rhs
}
public func -= <T: VectorType>(inout lhs: T, rhs: T) {
	lhs = lhs - rhs
}
public prefix func ++ <T: VectorType>(inout vector: T) -> T {
	let array = vector.arrayForm.map{ $0 + 1.0 }
	return T.init(fromArray: array)!
}
public prefix func -- <T: VectorType>(inout vector: T) -> T {
	let array = vector.arrayForm.map{ $0 - 1.0 }
	return T.init(fromArray: array)!
}
prefix operator +++ {}
public prefix func +++ <T: VectorType>(inout vector: T) -> T {
	vector += vector
	return vector
}
public func * <T: VectorType>(lhs: Double, rhs: T) -> T {
	let array = rhs.arrayForm.map{ lhs * $0 }
	return T.init(fromArray: array)!
}
public func * <T: VectorType>(lhs: T, rhs: Double) -> T {
	let array = lhs.arrayForm.map{ rhs * $0 }
	return T.init(fromArray: array)!
}
public func *= <T: VectorType>(inout lhs: T, rhs: Double) {
	lhs = lhs * rhs
}
public func / <T: VectorType>(lhs: T, rhs: Double) -> T {
	guard !lhs.isZeroVector else { return lhs }
	guard rhs != 0.0 else { fatalError("Invalid Operation.") }
	let array = lhs.arrayForm.map{ $0 / rhs }
	return T.init(fromArray: array)!
}
public func /= <T: VectorType>(inout lhs: T, rhs: Double) {
	lhs = lhs / rhs
}

infix operator +- { associativity left precedence 140 }
public func +- (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
	return Vector2D(x: lhs.x + rhs.x, y: lhs.y - rhs.y)
}
// Opposite Check
infix operator <-> { associativity left precedence 140 }
public func <-> <T: VectorType> (lhs: T, rhs: T) -> Bool {
	if -lhs == rhs {
		return true
	}
	return false
}
// Parallel Check
infix operator ||| { associativity left precedence 140 }
public func ||| <T: VectorType> (lhs: T, rhs: T) -> Bool {
	guard !lhs.isZeroVector && !rhs.isZeroVector else {
		return false
	}
	let auv: T = lhs.unitVector as! T
	let buv: T = rhs.unitVector as! T
	if auv == buv {
		return true
	}
	return false
}
// Antiparallel Check
infix operator !|| { associativity left precedence 140 }
public func !|| <T: VectorType> (lhs: T, rhs: T) -> Bool {
	guard !lhs.isZeroVector && !rhs.isZeroVector else {
		return false
	}
	let auv: T = lhs.unitVector as! T
	let buv: T = rhs.unitVector as! T
	if auv == -buv {
		return true
	}
	return false
}

public func * <T:VectorType>(lhs: T, rhs: T) -> Double {
	let laf = lhs.arrayForm
	let raf = rhs.arrayForm
	var array = [Double]()
	for i in 0..<laf.count {
		array.append(laf[i] * raf[i])
	}
	return array.reduce(0){ $0 + $1 }
}

// Perpendicular Check
infix operator -| { associativity left precedence 140 }
public func -| <T: VectorType> (lhs: T, rhs: T) -> Bool {
	guard !lhs.isZeroVector && !rhs.isZeroVector else {
		return false
	}
	if lhs * rhs == 0 {
		return true
	}
	return false
}

infix operator × { associativity left precedence 140 }
public func × (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
	return Vector3D(x: lhs.y * rhs.z - lhs.z * rhs.y,
	                y: lhs.z * rhs.x - lhs.x * rhs.z,
	                z: lhs.x * rhs.y - lhs.y * rhs.x)
}

//Linear interpolation
public func lerp<T: VectorType>(start start: T, end: T, t: Double) -> T {
	return start + (end - start) * t
}



