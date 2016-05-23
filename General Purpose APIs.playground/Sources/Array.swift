import Foundation
/// General Use
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
/// General Use
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
/// General Use
public extension Array {
	/// shuffle: randly reorder array `self`
	public mutating func shuffle() {
		for i in (count - 1).stride(through: 1, by: -1) {
			let j = Int(arc4random_uniform(UInt32(i + 1)))
			if i != j {
				swap(&self[i], &self[j])
			}
		}
	}
}


/// For DNN
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
	public static func fillVec(n: Int, value:Element) -> [Element] {
		return [Element](count: n, repeatedValue: value)
	}
	public static func fillMat(row: Int, col: Int, value:Element) -> [[Element]] {
		return [[Element]](count: row, repeatedValue: [Element](count: col, repeatedValue: value))
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
	public static func mapTwoVec(vec1: [Element], vec2: [Element], activation: (Element, Element) -> Element) -> [Element] {
		guard vec1.count == vec2.count else { fatalError("Matrix shape error : not same") }
		var result = vec1
		for i in vec1.indices {
			result[i] = activation(vec1[i], vec2[i])
		}
		return result
	}
	public static func mapTwoMat(mat1: [[Element]], mat2: [[Element]], activation: (Element, Element) -> Element) -> [[Element]] {
		guard mat1.count == mat2.count && mat1[0].count == mat2[0].count else { fatalError("Matrix shape error : not same") }
		var result = mat1
		for i in 0..<mat1.count {
			for j in 0..<mat1[0].count {
				result[i][j] = activation(mat1[i][j],mat2[i][j])
			}
		}
		return result
	}
	public func min() -> Element {
		guard let min = self.minElement() else { fatalError("wrong to get min") }
		return min
	}
	public func max() -> Element {
		guard let max = self.maxElement() else { fatalError("wrong to get max") }
		return max
	}
	public func squareVec() -> [Element] {
		return self.map{ $0 * $0 }
	}
	public func softmaxVec() -> [Element] {
		guard let max = self.maxElement() else { fatalError("vec wrong: wrong to get max") }
		let preSoftmaxVec = self.map{ x in
			return Element() is Double ? exp((x - max) as! Double) as! Element : exp(Double((x - max).toInt())).toInt() as! Element
		}
		return preSoftmaxVec.map{ $0 / ∑preSoftmaxVec }
	}
}
/// For DNN
public extension Array where Element: CollectionType, Element.Generator.Element: SummableMultipliable {
	public func min() -> Element.Generator.Element {
		let x = self.flatten().map{ $0 }
		guard let min = x.minElement() else { fatalError("wrong to get min") }
		return min
	}
	public func max() -> Element.Generator.Element {
		let x = self.flatten().map{ $0 }
		guard let max = x.maxElement() else { fatalError("wrong to get max") }
		return max
	}
	public func mapMat(activation: (Element.Generator.Element) -> Element.Generator.Element) -> [[Element.Generator.Element]] {
		return self.map{ $0.map{ activation($0) } }
	}
	public func squareMat() -> [[Element.Generator.Element]] {
		return self.mapMat{ $0 * $0 }
	}
	public func probToBinaryMat() -> [[Element.Generator.Element]] {
		let one = Element.Generator.Element.one
		let zero = Element.Generator.Element.zero
		return self.mapMat{ $0.toDouble() > Double.rand() ? one : zero }
	}
	public func softmaxMat() -> [[Element.Generator.Element]] {
		var x = Array<Element.Generator.Element>.zeroMat(self.count, col: self[0].count as! Int)
		x = self.mapMat{ $0 }
		return x.map{ $0.softmaxVec() }
	}
}

infix operator *! { associativity left precedence 150 }
public func *! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
	return lhs.replace(rhs, op: *)
}
public func *! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
	return lhs.replace(rhs, op: Array.mul)
}
public func *! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
	return lhs.map{ $0.replace(rhs, op: *) }
}

infix operator /! { associativity left precedence 150 }
public func /! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
	return lhs.replace(rhs, op: /)
}
public func /! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
	return lhs.replace(rhs, op: Array.div)
}
public func /! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
	return lhs.map{ $0.replace(rhs, op: /) }
}

infix operator +! { associativity left precedence 140 }
public func +! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
	return lhs.replace(rhs, op: +)
}
public func +! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
	return lhs.replace(rhs, op: Array.add)
}
public func +! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
	return lhs.map{ $0.replace(rhs, op: +) }
}

infix operator -! { associativity left precedence 140 }
public func -! <T: SummableMultipliable>(lhs: [T], rhs: T) -> [T] {
	return lhs.replace(rhs, op: -)
}
public func -! <T: SummableMultipliable>(lhs: [[T]], rhs: [T]) -> [[T]] {
	return lhs.replace(rhs, op: Array.sub)
}
public func -! <T: SummableMultipliable>(lhs: [[T]], rhs: T) -> [[T]] {
	return lhs.map{ $0.replace(rhs, op: -) }
}

infix operator *!= { associativity right precedence 90 }
public func *!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
	lhs = lhs *! rhs
}
public func *!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
	lhs = lhs *! rhs
}
public func *!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
	lhs = lhs *! rhs
}

infix operator /!= { associativity right precedence 90 }
public func /!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
	lhs = lhs /! rhs
}
public func /!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
	lhs = lhs /! rhs
}
public func /!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
	lhs = lhs /! rhs
}

infix operator +!= { associativity right precedence 90 }
public func +!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
	lhs = lhs +! rhs
}
public func +!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
	lhs = lhs +! rhs
}
public func +!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
	lhs = lhs +! rhs
}

infix operator -!= { associativity right precedence 90 }
public func -!= <T: SummableMultipliable>(inout lhs: [T], rhs: T) {
	lhs = lhs -! rhs
}
public func -!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: [T]) {
	lhs = lhs -! rhs
}
public func -!= <T: SummableMultipliable>(inout lhs: [[T]], rhs: T){
	lhs = lhs -! rhs
}

public func + <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
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
public func - <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] - rhs[i])
	}
	return result
}
public func * <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] * rhs[i])
	}
	return result
}
public func / <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == rhs.count else { fatalError("Length Error : not same.") }
	guard !rhs.contains(T())else { fatalError("Divide to zero.") }
	var result = [T]()
	for i in lhs.indices {
		result.append(lhs[i] / rhs[i])
	}
	return result
}

public func + <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
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
public func - <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
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
public func * <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
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
public func / <T: SummableMultipliable>(lhs: [[T]], rhs: [[T]]) -> [[T]] {
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
infix operator ** { associativity left precedence 150 }
public func ** <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> T {
	guard lhs.count == rhs.count else { fatalError("Vector mismatch") }
	var result = T()
	for i in 0..<lhs.count {
		result += lhs[i] * rhs[i]
	}
	return result
}

public func × <T: SummableMultipliable>(lhs: [T], rhs: [T]) -> [T] {
	guard lhs.count == 3 && rhs.count == 3 else { fatalError("cross product is only for 3-dimensional vectors") }
	let x1 = lhs[0], y1 = lhs[1], z1 = lhs[2]
	let x2 = rhs[0], y2 = rhs[1], z2 = rhs[2]
	return [y1 * z2 - z1 * y2,
	        z1 * x2 - x1 * z2,
	        x1 * y2 - y1 * x2]
}

public postfix func -| <T: SummableMultipliable>(lhs: [[T]]) -> [[T]] {
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

infix operator ⨂ { associativity left precedence 150 }

public func ⨂ <T: SummableMultipliable>(lhs: [T], rhs:[T]) -> [[T]] {
	let mat1 = [lhs]-|
	let mat2 = [rhs]
	return mat1 × mat2
}

prefix operator ∑ {}

public prefix func ∑ <T: SummableMultipliable>(rhs:[T]) -> T {
	return rhs.reduce(T()){ $0 + $1 }
}
public prefix func ∑ <T: SummableMultipliable>(rhs:[[T]]) -> T {
	return rhs.flatMap{ ∑$0 }.reduce(T()){ $0 + $1 }
}
infix operator ∑ { associativity right precedence 150 }
public func ∑ <T: SummableMultipliable>(lhs: Int, rhs:[[T]]) -> [T] {
	guard lhs == 0 || lhs == 1 else { fatalError("lhs means summation direction, 1 for row, 0 for column") }
	// axis 0 : sum of col vector . axis 1 : sum of row vector
	if lhs == 1 {
		return rhs.flatMap{ ∑$0 }
	} else {
		return (rhs-|).flatMap{ ∑$0 }
	}
}

prefix operator ∀ {}
public prefix func ∀ <T: SummableMultipliable>(rhs:[T]) -> T {
	if T() is Double {
		return (∑rhs).toDouble() / rhs.count.toDouble() as! T
	}
	return ∑rhs / (rhs.count as! T)
}
public prefix func ∀ <T: SummableMultipliable>(rhs:[[T]]) -> T {
	if T() is Double {
		return (∑rhs).toDouble() / rhs.count.toDouble() / rhs[0].count.toDouble() as! T
	}
	return (∑rhs) / (rhs.count as! T) / (rhs[0].count as! T)
}
infix operator ∀ { associativity right precedence 150 }
public func ∀ <T: SummableMultipliable>(lhs: Int, rhs:[[T]]) -> [T] {
	// axis 0 : mean of col vector . axis 1 : mean of row vector
	guard lhs == 0 || lhs == 1 else { fatalError("lhs means summation direction, 1 for row, 0 for column") }
	if lhs == 1 {
		return rhs.flatMap{ ∀$0 }
	} else {
		return (rhs-|).flatMap{ ∀$0 }
	}
}

