/*:
[Previous](@previous)
****
# SWIFT Array Extension

## Replace Array element with definded operations

Sometimes, we need to change all element in the array. Here comes a easy way to replace all elements in the array or creat a new array to store this change.

	Example:
	[1, 2, 3, 4] -> [5, 6, 7, 8]    >> each element is added by 4.

We can easily use a native map function to achieve.

	let newArray = [1, 2, 3, 4].map{ $0 + 4 }		// [5, 6, 7, 8]

If the arry we want to handle is multi-dimational, there are more steps we have to do. For example, we have a 3x3 matrix form array **mat**. 
**mat** = [[1, 2, 3], [2, 4, 6], [5, 10, 15]]. 
We want to get a new array in which each element array is divided by another array [1, 2, 3], i.e. for the first element [1, 2, 3] after operation the first sub-element is 1/1 and followed by 2/2, 3/3 . Finally, the new array is become [[1, 1, 1], [2, 2, 2], [5, 5, 5]]. We can easily find the operation is like `array.forEach{ $0 / [1, 2, 3] }`. We can write a closure to deal with two arrays to obtain a new array and become effective for each array.

There are many methods to obtain an array by passing two arrays, 3-dimensional vector's cross product is an example. It is too hard to achieve by implementing closures everytime. Following is the implematation for simplifying the process.
*/

import Foundation

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

****
[Next](@next)
*/
