/*:
[Previous](@previous)
****
# SWIFT String Extension

## String Indices 
### [Described in 'The Swift Programming Language (Swift 2.2)' by Apple Inc.]

Each String value has an associated index type, String.Index, which corresponds to the position of each Character in the string.

As mentioned above, different characters can require different amounts of memory to store, so in order to determine which Character is at a particular position, you must iterate over each Unicode scalar from the start or end of that String. For this reason, Swift strings cannot be indexed by integer values.

Use the startIndex property to access the position of the first Character of a String. The endIndex property is the position after the last character in a String. As a result, the endIndex property isn’t a valid argument to a string’s subscript. If a String is empty, startIndex and endIndex are equal.

A String.Index value can access its immediately preceding index by calling the predecessor() method, and its immediately succeeding index by calling the successor() method. Any index in a String can be accessed from any other index by chaining these methods together, or by using the advancedBy(_:) method. Attempting to access an index outside of a string’s range will trigger a runtime error.

You can use subscript syntax to access the Character at a particular String index.

## Use an integer indexing subscription to access Swift strings

By using the advancedBy(_:) method, we can use an integer number to alternatively index a Swift string.

## Use an integer range subscription to access Swift strings

*/
import UIKit

public extension String {
	subscript(idx: Int) -> Character {
		get {
			let strIdx = self.startIndex.advancedBy(idx, limit: endIndex)
			guard strIdx != endIndex else { fatalError("String index out of bounds") }
			return self[strIdx]
		}
		set {
			self.removeAtIndex(startIndex.advancedBy(idx, limit: endIndex))
			self.insert(newValue, atIndex: startIndex.advancedBy(idx, limit: endIndex))
		}
	}
	subscript(range: Range<Int>) -> String {
		get {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			return self[strRange]
		}
		set {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			self.removeRange(strRange)
			self.insertContentsOf(newValue.characters, at: strRange.startIndex)
		}
	}
	func visualizeView() -> UIView {
		return visualize(self)
	}
	func visualizeView(idx: Int) -> UIView {
		let index = self.startIndex.advancedBy(idx, limit: endIndex)
		return visualize(self, index: index)
	}
	func visualizeView(range: Range<Int>) -> UIView {
		let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
		return visualize(self, range: strRange)
	}
}

var exampleString = "This is an example of a Swift string."
exampleString.visualizeView()
exampleString.visualizeView(3)
visualize("\(exampleString[3])")
exampleString.visualizeView(11...17)
visualize("\(exampleString[11...17])")
exampleString[3] = "g"
exampleString.visualizeView(3)
exampleString[8...17] = "a sample"
exampleString.visualizeView(10...15)
exampleString[8...15] = "an example"
exampleString.visualizeView(11...17)
exampleString[3...3] = "🤖"
exampleString.visualizeView(3)
exampleString[3] = "s"
exampleString.visualizeView()

extension String {
	// 字串倒轉
	public func reverse() -> String {
		let array = self.characters
		var reverse = String.CharacterView()
		for i in 0..<array.count {
			let index = -i - 1
			reverse.append(array[array.endIndex.advancedBy(index)])
		}
		return String(reverse)
	}
}
exampleString.reverse().visualizeView()




/*:
****
[Next](@next)
*/
