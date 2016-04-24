import Foundation

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
///Rang的型別擴充, 其Scope只在相同的命名空間, 其為Generic型別不可public給其他命名空間
extension Range {
	//在指定範圍之內取亂數
	public func rand() -> Int? {
		func randomInRange(range: Range<Int>) -> Int {
			let count = UInt32(range.endIndex - range.startIndex)
			return Int(arc4random_uniform(count)) + range.startIndex
		}
		let s = startIndex as! Int
		let e = endIndex as! Int
		if s >= 0 && e <= 2147483647 && e>s {
			return randomInRange(s..<e)
		} else {
			return nil
		}
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

