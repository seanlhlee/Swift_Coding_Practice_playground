import Foundation

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
