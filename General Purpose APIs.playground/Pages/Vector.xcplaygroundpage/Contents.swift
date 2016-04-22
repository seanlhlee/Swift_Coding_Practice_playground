/*:
[Previous](@previous)
****

# Vector

## Representations

Vector arrow pointing from A to B

![](1.png "")

Vectors are usually denoted in lowercase boldface, as **a** or lowercase italic boldface, as *a*. 
If the vector represents a directed distance or displacement from a point A to a point B (see figure), it can also be denoted as ![](ab.png) or AB.

Vectors are usually shown in graphs or other diagrams as arrows, as illustrated in the figure. Here the point A is called the origin, tail, base, or initial point; point B is called the head, tip, endpoint, terminal point or final point. The length of the arrow is proportional to the vector's magnitude, while the direction in which the arrow points indicates the vector's direction.

On a two-dimensional diagram, sometimes a vector perpendicular to the plane of the diagram is desired. These vectors are commonly shown as small circles. A circle with a dot at its centre (Unicode U+2299 ⊙) indicates a vector pointing out of the front of the diagram, toward the viewer. A circle with a cross inscribed in it (Unicode U+2297 ⊗) indicates a vector pointing into and behind the diagram. These can be thought of as viewing the tip of an arrow head on and viewing the flights of an arrow from the back.

![](4.png "")

![](2.png "")

A vector in the Cartesian plane, showing the position of a point A with coordinates (2,3).

In order to calculate with vectors, the graphical representation may be too cumbersome. Vectors in an n-dimensional Euclidean space can be represented as coordinate vectors in a Cartesian coordinate system. The endpoint of a vector can be identified with an ordered list of n real numbers (n-tuple). These numbers are the coordinates of the endpoint of the vector, with respect to a given Cartesian coordinate system, and are typically called the scalar components (or scalar projections) of the vector on the axes of the coordinate system.

As an example in two dimensions (see figure), the vector from the origin O = (0,0) to the point A = (2,3) is simply written as

**a** = (2,3).

The notion that the tail of the vector coincides with the origin is implicit and easily understood. Thus, the more explicit notation ![](oa.png) is usually not deemed necessary and very rarely used.


![](3.png "")

In three dimensional Euclidean space (or **R**³), vectors are identified with triples of scalar components:

**a** = (a₁, a₂, a₃).

also written

![](xyz.png)

This can be generalised to n-dimensional Euclidean space (or Rn).

**a** = (a₁, a₂, a₃,..., an).

These numbers are often arranged into a column vector or row vector, particularly when dealing with matrices, as follows:

![](vec.png)
*/
import Foundation
public protocol VectorType {
	associatedtype Vector
	init?(fromArray: [Double])
	var isZeroVector: Bool { get }
	var unitVector: Vector { get }
	var arrayForm: [Double] { get set }
	func == (lhs: Vector, rhs: Vector) -> Bool
}

public struct Vector2D: VectorType, Equatable,CustomStringConvertible {
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
import UIKit
extension Vector2D: Visualization {
	public typealias Index = Int
	public func visualizeView() -> UIView {
		return self.arrayForm.visualizeView()
	}
}

extension Vector3D: Visualization {
	public typealias Index = Int
	public func visualizeView() -> UIView {
		return self.arrayForm.visualizeView()
	}
}



let v1 = Vector3D(x: 3, y: 4, z: 0)
v1.visualizeView()

let v2 = Vector3D(x: -3, y: -4, z: 0)
v2.visualizeView()
let v3 = Vector3D(x: -6, y: -8, z: 0)
v3.visualizeView()


v1 <-> v2
v1.length

v1 ||| v3
v2 ||| v3
v1 !|| v3
/*:
## Dot product
Main article: Dot product
The dot product of two vectors **a** and **b** is denoted by **a** ∙ **b** and is defined as:

![](dot1.png)

where θ is the measure of the angle between **a** and **b**. Geometrically, this means that **a** and **b** are drawn with a common start point and then the length of a is multiplied with the length of that component of b that points in the same direction as a.

The dot product can also be defined as the sum of the products of the components of each vector as

![](dot2.png)

*/
public func * <T:VectorType>(lhs: T, rhs: T) -> Double {
	let laf = lhs.arrayForm
	let raf = rhs.arrayForm
	var array = [Double]()
	for i in 0..<laf.count {
		array.append(laf[i] * raf[i])
	}
	return array.reduce(0){ $0 + $1 }
}
v1
v2
v1 * v2


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

let v4 = Vector3D(x: 0, y: 0, z: 1)
v2 -| v3
v2 -| v4

/*:
## Cross product

The cross product is only meaningful in three or seven dimensions. The cross product differs from the dot product primarily in that the result of the cross product of two vectors is a vector. The cross product, denoted **a** × **b**, is a vector perpendicular to both **a** and **b** and is defined as

![](cross1.png)

where θ is the measure of the angle between **a** and **b**, and n is a unit vector perpendicular to both **a** and **b** which completes a rhs-handed system. The rhs-handedness constraint is necessary because there exist two unit vectors that are perpendicular to both **a** and **b**, namely, **n** and (–**n**).


#### An illustration of the cross product

The cross product **a** × **b** is defined so that **a**, **b**, and **a** × **b** also becomes a rhs-handed system (but note that **a** and **b** are not necessarily orthogonal). This is the rhs-hand rule.

The length of **a** × **b** can be interpreted as the area of the parallelogram having **a** and **b** as sides.

The cross product can be written as

![](cross2.png)

*/
infix operator × { associativity left precedence 140 }
public func × (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
	return Vector3D(x: lhs.y * rhs.z - lhs.z * rhs.y,
	                y: lhs.z * rhs.x - lhs.x * rhs.z,
	                z: lhs.x * rhs.y - lhs.y * rhs.x)
}

let xAxis = Vector3D(x: 1, y: 0, z: 0)
let yAxis = Vector3D(x: 0, y: 1, z: 0)
let zAxis = xAxis × yAxis
xAxis.arrayForm.visualizeView()
yAxis.arrayForm.visualizeView()
zAxis.arrayForm.visualizeView()

/*: 
## Linear interpolation

In mathematics, linear interpolation is a method of curve fitting using linear polynomials to construct new data points within the range of a discrete set of known data points.

![](Linear_interpolation.png)

![](lerp.png)
*/
public func lerp<T: VectorType>(start start: T, end: T, t: Double) -> T {
	return start + (end - start) * t
}
v1.arrayForm.visualizeView()
v2.arrayForm.visualizeView()
let linear_interpolation = lerp(start: v1, end: v2, t: 0.3)
linear_interpolation.arrayForm.visualizeView()

/*:
****
[Next](@next)
*/


/*:
> 以下內容為運算子設計的練習，練習部分對象為UIColor，僅為練習程式上的設計邏輯，與實際的光學物理無關。
*/


//以下為練習, 顏色的數學實際上不是這樣的

import UIKit

// Custom Operators
infix operator ** { associativity left precedence 160 }
func ** (lhs: Double, rhs: Double) -> Double {
	return pow(lhs, rhs)
}

2 ** 3 // 8

// When creating custom operators, make sure to also create the corresponding assignment operator, if appropriate:

infix operator **= { associativity right precedence 90 }
func **= (inout lhs: Double, rhs: Double) {
	lhs = lhs ** rhs
}

// Use of Mathematical Symbols
prefix operator √ {}
prefix func √ (number: Double) -> Double {
	return sqrt(number)
}
√16
√2

infix operator ± { associativity left precedence 140 }
func ± (lhs: Double, rhs: Double) -> (Double, Double) {
	return (lhs + rhs, lhs - rhs)
}

prefix operator ± {}
prefix func ± (value: Double) -> (Double, Double) {
	return 0 ± value
}

2 ± 3
±4




func == (lhs: UIColor, rhs: UIColor) -> Bool {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	lhs.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	rhs.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
	return rl == rr && gl == gr && bl == br && al == ar
}

let white1 = UIColor.whiteColor()
let white2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
white1 == white2
let gray1 = UIColor.grayColor()
gray1 == white1

func + (lhs: UIColor, rhs: UIColor) -> UIColor {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	lhs.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	rhs.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
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

func - (lhs: UIColor, rhs: UIColor) -> UIColor {
	var rl:CGFloat = 0, gl:CGFloat = 0, bl:CGFloat = 0, al:CGFloat = 0
	lhs.getRed(&rl, green: &gl, blue: &bl, alpha: &al)
	var rr:CGFloat = 0, gr:CGFloat = 0, br:CGFloat = 0, ar:CGFloat = 0
	rhs.getRed(&rr, green: &gr, blue: &br, alpha: &ar)
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

/*:
****
[Next](@next)
*/
