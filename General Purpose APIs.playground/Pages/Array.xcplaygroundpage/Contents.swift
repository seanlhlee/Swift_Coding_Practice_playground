/*:
[Previous](@previous)
****
# SWIFT Array Extension

## Zero/One Array for vector & matrix
*/

/*
public extension Array where Element: SummableMultipliable {
	public static func zeroVec(n: Int) -> [Element] {
		return [Element](count: n, repeatedValue: Element())
	}
	public static func zeroMat(row: Int, col: Int) -> [[Element]] {
		return [[Element]](count: row, repeatedValue: [Element](count: col, repeatedValue: Element()))
	}
	public static func oneVec(n: Int) -> [Element] {
		if Element() is Double {
			return [Element](count: n, repeatedValue: 1.toDouble() as! Element)
		}
		return [Element](count: n, repeatedValue: 1 as! Element)
	}
	public static func oneMat(row: Int, col: Int) -> [[Element]] {
		if Element() is Double {
			return [[Element]](count: row, repeatedValue: [Element](count: col, repeatedValue: 1.toDouble() as! Element))
		}
		return [[Element]](count: row, repeatedValue: [Element](count: col, repeatedValue: 1 as! Element))
	}
	public static func randVec(n: Int, lower: Element, upper: Element) -> [Element] {
		let l = lower <= upper ? lower.toDouble() : upper.toDouble()
		let u = lower <= upper ? upper.toDouble() : upper.toDouble()
		let result = [Double].zeroVec(n)
		if Element() is Double {
			return result.map{ _ in l + (u - l) * Double.rand() as! Element }
		}
		return result.flatMap{ _ in ((l + (u - l) * Double.rand()).toInt() as! Element) }
	}
	public static func randMat(row: Int, col: Int, lower: Element, upper: Element) -> [[Element]] {
		let result = zeroMat(row, col: col)
		return result.map{ _ in randVec(col, lower: lower, upper: upper) }
	}
	
	public static func randnVec(n: Int, mean: Element, sigma: Element) -> [Element] {
		let result = zeroVec(n)
		return result.map{ _ in
			if Element() is Double {
				return mean.toDouble() + sigma.toDouble() * Double.randn() as! Element
			}
			return (mean.toDouble() + sigma.toDouble() * Double.randn()).toInt() as! Element
		}
	}
	public static func randnMat(row: Int, col: Int, mean: Element, sigma: Element) -> [[Element]] {
		let result = zeroMat(row, col: col)
		return result.map{ _ in randnVec(col, mean: mean, sigma: sigma) }
	}
	public static func identity(n: Int) -> [[Element]] {
		var result = zeroMat(n, col: n)
		for i in 0..<n {
			result[i][i] = Element() is Double ? 1.0 as! Element : 1.0.toInt() as! Element
		}
		return result
	}
	
}
*/

import Foundation
[Int].zeroVec(3)
[Double].zeroMat(3, col: 2)
[Int].oneVec(3)
[Double].oneMat(3, col: 2)
[Int].randVec(10,lower: 3,upper: 8)
[Double].randVec(10,lower: 3,upper: 8)
[Int].randMat(2, col: 4, lower: 0, upper: 10)
[Double].randMat(3, col: 3, lower: 0, upper: 10)
[Int].randnVec(10, mean: 5, sigma: 10)
[Double].randnVec(10, mean: 5, sigma: 10)
[Double].randnMat(3, col: 3, mean: 0, sigma: 10)
[Int].identity(3)
[Double].identity(3)
var sigmoid_pre = 8.0
sigmoid_pre.sigmoid()
Math.sigmoid(8.0)
sigmoid_pre.dSigmoid()
Math.dSigmoid(Math.sigmoid(8.0))

/*:
## Replace Array element with definded operations

Sometimes, we need to change all element in the array. Here comes a easy way to replace all elements in the array or creat a new array to store this change, if the element of the array is confirmed to SummableMultipliable protocol.

	Example:
	[1, 2, 3, 4] -> [5, 6, 7, 8]    >> each element is added by 4.

We can easily use a native map function to achieve.

	let newArray = [1, 2, 3, 4].map{ $0 + 4 }		// [5, 6, 7, 8]

If the arry we want to handle is multi-dimational, there are more steps we have to do. For example, we have a 3x3 matrix form array **mat**. 
**mat** = [[1, 2, 3], [2, 4, 6], [5, 10, 15]]. 
We want to get a new array in which each element array is divided by another array [1, 2, 3], i.e. for the first element [1, 2, 3] after operation the first sub-element is 1/1 and followed by 2/2, 3/3 . Finally, the new array is become [[1, 1, 1], [2, 2, 2], [5, 5, 5]]. We can easily find the operation is like `array.forEach{ $0 / [1, 2, 3] }`. We can write a closure to deal with two arrays to obtain a new array and become effective for each array.

There are many methods to obtain an array by passing two arrays, 3-dimensional vector's cross product is an example. It is too hard to achieve by implementing closures everytime. Following is the implematation for simplifying the process.
*/

let newArray = [1,2,3,4].map{$0+4}
newArray.visualizeView()

var mat = [[1, 2, 3], [2, 4, 6], [5, 10, 15]]
mat.visualizeView()

let new = mat.replace([1,2,3], op: Array.div)
new.visualizeView()



/*:
	public extension Array where Element: SummableMultipliable {
		public func replace(e: Element, op: ((Element, Element)->(Element))? ) -> Array<Element> {
			var result = self
			if let o = op {
				for i in self.indices {
					let x = o(self[i], e)
					result.replaceRange(i...i, with: [x])
				}
			} else {
				for i in self.indices {
					result.replaceRange(i...i, with: [e])
				}
			}
			return result
		}
		public mutating func replaced(e: Element, op: ((Element, Element)->(Element))? ) {
			self = self.replace(e, op: op)
		}
		private static func operatable(a: Array<Element>, _ b: Array<Element>) -> Bool {
			guard !a.isEmpty && !b.isEmpty else { return false }
			guard a.count == b.count else { print("the counts of element is not the same"); return false }
			return true
		}
		
		public static func add(a: Array<Element>, b: Array<Element>) -> Array<Element> {
			guard operatable(a,b) else { return Array<Element>() }
			var result = Array<Element>()
			for i in a.indices {
				result.append(a[i] + b[i])
			}
			return result
		}
		public static func sub(a: Array<Element>, b: Array<Element>) -> Array<Element> {
			guard operatable(a,b) else { return Array<Element>() }
			var result = Array<Element>()
			for i in a.indices {
				result.append(a[i] - b[i])
			}
			return result
		}
		public static func mul(a: Array<Element>, b: Array<Element>) -> Array<Element> {
			guard operatable(a,b) else { return Array<Element>() }
			var result = Array<Element>()
			for i in a.indices {
				result.append(a[i] * b[i])
			}
			return result
		}
		public static func div(a: Array<Element>, b: Array<Element>) -> Array<Element> {
			guard operatable(a,b) else { return Array<Element>() }
			var result = Array<Element>()
			for i in a.indices {
				// Element() is 0
				let x = b[i] == Element() ? Element() : a[i] / b[i]
				result.append(x)
			}
			return result
		}
	}
	public extension Array where Element: ArrayLiteralConvertible {
		public func replace(e: Element, op: ((Element, Element)->(Element))? ) -> Array<Element> {
			var result = self
			if let o = op {
				for i in self.indices {
					let x = o(self[i], e)
					result.replaceRange(i...i, with: [x])
				}
			} else {
				for i in self.indices {
					result.replaceRange(i...i, with: [e])
				}
			}
			return result
		}
		public mutating func replaced(e: Element, op: ((Element, Element)->(Element))? ) {
			self = self.replace(e, op: op)
		}
	}

## Define new operator

Arithmetic operator( + - * /) following with !.

	Operator		  Description					Associativity						Precedence
	______________________________________________________________________________
	   *!				Multiply					Left associative				Multiplicative, 150
	   /!				Divide						Left associative				Multiplicative, 150
	   +!				Add							Left associative				Additive, 140
	   -!				Subtract					Left associative				Additive, 140
	   *!=				Multiply and assign		Right associative				Multiplicative, 90
	   /!=				Divide and assign			Right associative				Multiplicative, 90
	   +!=				Add	 and assign				Right associative				Additive, 90
	   -!=				Subtract and assign		Right associative				Additive, 90
	______________________________________________________________________________

	   %!				Remainder					Left associative			Multiplicative, 150
	(not implement)

****

	infix operator *! { associativity left precedence 150 }
	func *! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
		return lhs.replace(rhs, op: *)
	}
	func *! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
		return lhs.replace(rhs, op: Array.mul)
	}
	func *! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
		return lhs.map{ $0.replace(rhs, op: *) }
	}

	infix operator /! { associativity left precedence 150 }
	func /! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
		return lhs.replace(rhs, op: /)
	}
	func /! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
		return lhs.replace(rhs, op: Array.div)
	}
	func /! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
		return lhs.map{ $0.replace(rhs, op: /) }
	}

	infix operator +! { associativity left precedence 140 }
	func +! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
		return lhs.replace(rhs, op: +)
	}
	func +! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
		return lhs.replace(rhs, op: Array.add)
	}
	func +! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
		return lhs.map{ $0.replace(rhs, op: +) }
	}

	infix operator -! { associativity left precedence 140 }
	func -! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
		return lhs.replace(rhs, op: -)
	}
	func -! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
		return lhs.replace(rhs, op: Array.sub)
	}
	func -! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
		return lhs.map{ $0.replace(rhs, op: -) }
	}

	infix operator *!= { associativity right precedence 90 }
	func *!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
		lhs = lhs *! rhs
	}
	func *!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
		lhs = lhs *! rhs
	}
	func *!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
		lhs = lhs *! rhs
	}

	infix operator /!= { associativity right precedence 90 }
	func /!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
		lhs = lhs /! rhs
	}
	func /!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
		lhs = lhs /! rhs
	}
	func /!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
		lhs = lhs /! rhs
	}

	infix operator +!= { associativity right precedence 90 }
	func +!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
		lhs = lhs +! rhs
	}
	func +!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
		lhs = lhs +! rhs
	}
	func +!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
		lhs = lhs +! rhs
	}

	infix operator -!= { associativity right precedence 90 }
	func -!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
		lhs = lhs -! rhs
	}
	func -!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
		lhs = lhs -! rhs
	}
	func -!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
		lhs = lhs -! rhs
	}
*/
let vet = [1,2,3]
(vet +! 5).visualizeView()
(mat +! 5).visualizeView()
(mat +! [1,2,3]).visualizeView()

(vet -! 5).visualizeView()
(mat -! 5).visualizeView()
(mat -! [1,2,3]).visualizeView()

(vet *! 5).visualizeView()
(mat *! 5).visualizeView()
(mat *! [1,2,3]).visualizeView()

(vet /! 5).visualizeView()
(mat /! 5).visualizeView()
(mat /! [1,2,3]).visualizeView()

/*:
## Redefine arithmetic opertors for memberwise operations of Arrays

example: [1,2,3] + [4,5,6] ==> [5,7,9],   [1,2,3] + [5,6] ==> [1,2,3,5,6], [1,2,3] * [3,2,1] ==> [3,4,3]

*/
/*
func + <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else {
		var result = lhs
		for i in rhs.indices {
			result.append(rhs[i])
		}
		return result
	}
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] + rhs[i])
	}
	return result
}
func - <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] - rhs[i])
	}
	return result
}
func * <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] * rhs[i])
	}
	return result
}
func / <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	guard !rhs.contains(T())else { fatalError("Divide to zero.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] / rhs[i])
	}
	return result
}

func + <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
	guard lhs.count == rhs.count else {
		var result = lhs
		for i in rhs.indices {
			result.append(rhs[i])
		}
		return result
	}
	var isSubCountEquivalence: Bool = true
	for i in lhs.indices {
		isSubCountEquivalence = lhs[i].count == rhs[i].count ? isSubCountEquivalence : false
	}
	guard isSubCountEquivalence else { fatalError("can't add") }
	
	var result = lhs
	for i in lhs.indices {
		result[i] = result[i] + rhs[i]
	}
	return result
}
func - <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var isSubCountEquivalence: Bool = true
	for i in lhs.indices {
		isSubCountEquivalence = lhs[i].count == rhs[i].count ? isSubCountEquivalence : false
	}
	guard isSubCountEquivalence else { fatalError("can't substrate") }
	
	var result = lhs
	for i in lhs.indices {
		result[i] = result[i] - rhs[i]
	}
	return result
}
func * <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var isSubCountEquivalence: Bool = true
	for i in lhs.indices {
		isSubCountEquivalence = lhs[i].count == rhs[i].count ? isSubCountEquivalence : false
	}
	guard isSubCountEquivalence else { fatalError("can't multiple") }
	
	var result = lhs
	for i in lhs.indices {
		result[i] = result[i] * rhs[i]
	}
	return result
}
func / <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var isSubCountEquivalence: Bool = true
	for i in lhs.indices {
		guard !rhs[i].contains(T())else { fatalError("Divide to zero.") }
		isSubCountEquivalence = lhs[i].count == rhs[i].count ? isSubCountEquivalence : false
	}
	guard isSubCountEquivalence else { fatalError("can't multiple") }

	var result = lhs
	for i in lhs.indices {
		result[i] = result[i] / rhs[i]
	}
	return result
}
*/
var vet1 = [6,5,4], vet2 = [3,2,1], vet3 = [1,2]
(vet1 + vet2).visualizeView()
(vet1 + vet3).visualizeView()
(vet1 - vet2).visualizeView()
(vet1 * vet2).visualizeView()
(vet1 / vet2).visualizeView()
var mat1 = [[6,5,4],[3,2,1]], mat2 = [[2,2,2],[1,1,1]], mat3 = [[1,2]]
(mat1 + mat2).visualizeView()
(mat1 + mat3).visualizeView()
(mat1 - mat2).visualizeView()
(mat1 * mat2).visualizeView()
(mat1 / mat2).visualizeView()
/*:
## Defind operator for dot product
	example: [3,4] dot [-3,-4] = -25

*/
/*
infix operator ** { associativity left precedence 150 }
func ** <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> T {
	guard lhs.count == rhs.count else { fatalError("Vector mismatch") }
	var result = T()
	for i in 0..<lhs.count {
		result += lhs[i] * rhs[i]
	}
	return result
}
*/
[3,4] ** [-3,-4]
[3,4,5] ** [-3,-4,-5]
/*:
## Defind operator for cross product
Remark: Only for 3-dimensional vectors

example: [3,4,0] × [-3,-1,0] = [0,0,9]

*/
/*
func × <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == 3 && rhs.count == 3 else { fatalError("cross product is only for 3-dimensional vectors") }
	let x1 = lhs[0], y1 = lhs[1], z1 = lhs[2]
	let x2 = rhs[0], y2 = rhs[1], z2 = rhs[2]
	return [y1 * z2 - z1 * y2,
	        z1 * x2 - x1 * z2,
	        x1 * y2 - y1 * x2]
}
*/
([3,4,0] × [-3,-1,0]).visualizeView()
/*:
## Defind operator for transpose of a vector
example: [6,5,4] -| = [[6], [5], [4]]
*/

/*
postfix func -| <T: SummableMultipliable>(lhs: [[T]]) -> [[T]] {
	guard !lhs.isEmpty else { return lhs }
	let e = [T](count: lhs.count, repeatedValue: T())
	var result = [[T]](count: lhs[0].count, repeatedValue: e)
	for i in 0..<result.count {
		for j in 0..<result[0].count {
			result[i][j] = lhs[j][i]
		}
	}
	return result
}
*/
vet1.visualizeView()
[vet1]-|.visualizeView()
/*:
## Defind operator for Matrix multiplication

example: [[6, 5, 4], [3, 2, 1]] × [[2, 1], [2, 1], [2, 1]] = [[30, 15], [12, 6]]

*/
/*
public func × <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
	//A: m x l  , B: l x n, C: m x n, cij = ai1b1j + ai2b2j + ... + ailblj
	guard !lhs.isEmpty && !rhs.isEmpty else { fatalError("Array mismatch") }				// check A, B is not empty
	let m = lhs.count
	let l = lhs[0].count
	let n = rhs[0].count
	guard !lhs[0].isEmpty && !rhs[0].isEmpty else { fatalError("Array mismatch") }	// check A sub, B sub is not empty
	guard lhs[0].count == rhs.count else { fatalError("Array mismatch") }					// check A columns and B rows is same l.
	for element in lhs {
		if element.count != l { fatalError("Array mismatch") }									// check each A row has same columns
	}
	for element in rhs {
		if element.count != n { fatalError("Array mismatch") }									// chech each B row has same columns
	}
	var matrix = Array<T>.zeroMat(m, col: n)
	let rhs_T: [[T]] = rhs-|
	for i in 0..<m {
		for j in 0..<n {
			matrix[i][j] = lhs[i] ** rhs_T[j]
		}
	}
	return matrix
}
*/
([[6, 5, 4], [3, 2, 1]] × [[2, 1], [2, 1], [2, 1]]).visualizeView()

var ma = Matrix(rows: 2, columns: 3, fromArray: [6,5,4,3,2,1])!
var mb = Matrix(rows: 3, columns: 2, fromArray: [2,1,2,1,2,1])!
(ma × mb)!.getRepresentative().visualizeView()

/*:
## Defind operator for outer product (Matrix multiplication)
example: [3,4] ⨂ [-3,-4] = [[-9, -12], [-12, -16]]

![](1.png)
*/
/*
infix operator ⨂ { associativity left precedence 150 }

func ⨂ <T: SummableMultipliable>(lhs: [T], rhs:[T]) -> [[T]] {
	let mat1 = [lhs]-|
	let mat2 = [rhs]
	return mat1 × mat2
}
*/
([3,4] ⨂ [-3,-4]).visualizeView()
/*:
## Defind operator for element summation
example: ∑[1,2,3,4,5,6,7,8,9] = 45
*/
/*
prefix operator ∑ {}

prefix func ∑ <T: SummableMultipliable>(rhs:[T]) -> T {
	return rhs.reduce(T()){ $0 + $1 }
}
prefix func ∑ <T: SummableMultipliable>(rhs:[[T]]) -> T {
	return rhs.flatMap{ ∑$0 }.reduce(T()){ $0 + $1 }
}
infix operator ∑ { associativity right precedence 150 }
func ∑ <T: SummableMultipliable>(lhs: Int, rhs:[[T]]) -> [T] {
	guard lhs == 0 || lhs == 1 else { fatalError("lhs means summation direction, 1 for row, 0 for column") }
	// axis 0 : sum of col vector . axis 1 : sum of row vector
	if lhs == 1 {
		return rhs.flatMap{ ∑$0 }
	} else {
		return (rhs-|).flatMap{ ∑$0 }
	}
}
*/
∑[1,2,3,4,5,6,7,8,9]
∑[[1,2,3],[4,5,6],[7,8,9]]

0∑[[1,2,3],[4,5,6],[7,8,9]]
1∑[[1,2,3],[4,5,6],[7,8,9]]

/*:
## Defind operator for everage value of all elements in an array
example: ∀[1,2,3,4,5,6,7,8,9] = 5
*/
/*
prefix operator ∀ {}
prefix func ∀ <T: SummableMultipliable>(rhs:[T]) -> T {
	if T() is Double {
		return (∑rhs).toDouble() / rhs.count.toDouble() as! T
	}
	return ∑rhs / (rhs.count as! T)
}
prefix func ∀ <T: SummableMultipliable>(rhs:[[T]]) -> T {
	if T() is Double {
		return (∑rhs).toDouble() / rhs.count.toDouble() / rhs[0].count.toDouble() as! T
	}
	return (∑rhs) / (rhs.count as! T) / (rhs[0].count as! T)
}
infix operator ∀ { associativity right precedence 150 }
func ∀ <T: SummableMultipliable>(lhs: Int, rhs:[[T]]) -> [T] {
	// axis 0 : mean of col vector . axis 1 : mean of row vector
	guard lhs == 0 || lhs == 1 else { fatalError("lhs means summation direction, 1 for row, 0 for column") }
	if lhs == 1 {
		return rhs.flatMap{ ∀$0 }
	} else {
		return (rhs-|).flatMap{ ∀$0 }
	}
}
*/
∀[1,2,3,4,5,6,7,8,9]
∀[[1,2,3],[4,5,6],[7,8,9]]
0∀[[1,2,3],[4,5,6],[7,8,9]]
1∀[[1,2,3],[4,5,6],[7,8,9]]

/*
## Defind operator for everage value of all elements in an array
example: ∀[1,2,3,4,5,6,7,8,9] = 5
*/


/*:
****
[Next](@next)
*/

