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

///Array的型別擴充, 其Scope只在相同的命名空間, 其為Generic型別不可public給其他命名空間
extension Array {
	///取得陣列中隨機的陣列索引
	public func randomIndex() -> Int? {
		return self.isEmpty ? nil : (0..<self.count).rand()
	}
	///陣列中元素隨機分佈
	public func randomize() -> [Element] {
		if !self.isEmpty {
			var tempArray = self
			var randomedArray: [Element] = []
			for _ in self {
				randomedArray.append(tempArray.removeAtIndex(tempArray.randomIndex()!))
			}
			return randomedArray
		} else {
			return []
		}
	}
}
