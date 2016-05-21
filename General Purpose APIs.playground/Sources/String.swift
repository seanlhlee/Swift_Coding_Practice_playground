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

public extension String {
	public func longestCommonSubsequence(other: String) -> String {
		
		func lcsLength(other: String) -> [[Int]] {
			
			var matrix = [[Int]](count: self.characters.count+1,
			                     repeatedValue: [Int](count: other.characters.count+1, repeatedValue: 0))
			
			for (i, selfChar) in self.characters.enumerate() {
				for (j, otherChar) in other.characters.enumerate() {
					if otherChar == selfChar {
						// Common char found, add 1 to highest lcs found so far.
						matrix[i+1][j+1] = matrix[i][j] + 1
					} else {
						// Not a match, propagates highest lcs length found so far.
						matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
					}
				}
			}
			
			return matrix
		}
		
		func backtrack(matrix: [[Int]]) -> String {
			var i = self.characters.count
			var j = other.characters.count
			
			var charInSequence = self.endIndex
			
			var lcs = String()
			
			while i >= 1 && j >= 1 {
				// Indicates propagation without change: no new char was added to lcs.
				if matrix[i][j] == matrix[i][j - 1] {
					j -= 1
				}
					// Indicates propagation without change: no new char was added to lcs.
				else if matrix[i][j] == matrix[i - 1][j] {
					i -= 1
					charInSequence = charInSequence.predecessor()
				}
					// Value on the left and above are different than current cell.
					// This means 1 was added to lcs length.
				else {
					i -= 1
					j -= 1
					charInSequence = charInSequence.predecessor()
					lcs.append(self[charInSequence])
				}
			}
			
			return String(lcs.characters.reverse())
		}
		
		return backtrack(lcsLength(other))
	}
	
	public static func longestCommonSubsequence(aString aString: String, bString: String) -> String {
		return aString.longestCommonSubsequence(bString)
	}
	
}