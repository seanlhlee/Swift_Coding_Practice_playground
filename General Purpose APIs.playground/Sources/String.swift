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

