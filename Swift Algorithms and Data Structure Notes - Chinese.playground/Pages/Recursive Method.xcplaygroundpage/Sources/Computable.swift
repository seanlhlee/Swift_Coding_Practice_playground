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
	public func randR() -> Int? {
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
	public func rndIndex() -> Int? {
		return self.isEmpty ? nil : (0..<self.count).randR()
	}
	///陣列中元素隨機分佈
	public func randomize() -> [Element] {
		if !self.isEmpty {
			var tempArray = self
			var randomedArray: [Element] = []
			for _ in self {
				randomedArray.append(tempArray.removeAtIndex(tempArray.rndIndex()!))
			}
			return randomedArray
		} else {
			return []
		}
	}
}


//數值形式之字面量
public protocol Computable { func toDouble() -> Double }

extension UInt: Computable { public func toDouble() -> Double { return Double(self) } }
extension Int8: Computable { public func toDouble() -> Double { return Double(self) } }
extension UInt8: Computable { public func toDouble() -> Double { return Double(self) } }
extension Int16: Computable { public func toDouble() -> Double { return Double(self) } }
extension UInt16: Computable { public func toDouble() -> Double { return Double(self) } }
extension Int32: Computable { public func toDouble() -> Double { return Double(self) } }
extension UInt32: Computable { public func toDouble() -> Double { return Double(self) } }
extension Int64: Computable { public func toDouble() -> Double { return Double(self) } }
extension UInt64: Computable { public func toDouble() -> Double { return Double(self) } }
extension Int: Computable { public func toDouble() -> Double { return Double(self) } }
extension Float: Computable { public func toDouble() -> Double { return Double(self) } }
extension Double: Computable { public func toDouble() -> Double { return self } }

//可顯示bit形式的整數型態, 方便使用
public protocol BitFormRepresentable { func toInt() -> Int }

extension UInt: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension Int8: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension UInt8: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension Int16: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension UInt16: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension Int32: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension UInt32: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension Int64: BitFormRepresentable { public func toInt() -> Int { return Int(self) } }
extension UInt64: BitFormRepresentable { public func toInt() -> Int { return self < (UInt64.max / 2) ? Int(self) : Int(self - UInt64.max / 2 - 1) } }
extension Int: BitFormRepresentable { public func toInt() -> Int { return self } }

public func + (lhs: Computable, rhs: Computable) -> Computable {
	return lhs.self + rhs.self
}
public func - (lhs: Computable, rhs: Computable) -> Computable {
	return lhs.self - rhs.self
}

extension BitFormRepresentable {
	// 二進位表示式
	public func bitRep(formatted: Bool = false) -> String {
		var size: Int
		switch self {
		case is Int8, is UInt8: size = 7
		case is Int16, is UInt16: size = 15
		case is Int32, is UInt32: size = 31
		case is Int64, is UInt64: size = 63
		default : size = 63
		}
		let n = self.toInt()
		var rep = ""
//		for (var c = size; c >= 0; c--){}
		for c in -size...0 {
			let k = n >> -c
			if (k & 1) == 1 { rep += "1" } else { rep += "0" }
			if -c%8  == 0 && c != 0  && formatted { rep += " " }
		}
		return rep
	}
	// 十六進位表示式
	public func hexRep(formatted: Bool = false) -> String {
		let size: Int = {
			switch self {
			case is Int8, is UInt8: return 1
			case is Int16, is UInt16: return 3
			case is Int32, is UInt32: return 7
			case is Int64, is UInt64: return 15
			default : return 15
			}
		}()
		var n = self.toInt()
		var rep = ""
		var reverse = [Character]()
		for _ in 0...size {
			let k: Character = {
				let x = n % 16
				switch x {
				case 0...9:
					return x.description.characters.last!
				case 10:
					return "A"
				case 11:
					return "B"
				case 12:
					return "C"
				case 13:
					return "D"
				case 14:
					return "E"
				case 15:
					return "F"
				default:
					return "0"
				}
			}()
			n = n / 16
			reverse.append(k)
		}
		for i in 0..<reverse.count {
			rep.append(reverse[reverse.count - i - 1])
			if ((reverse.count - i - 1) % 4 == 0 && (reverse.count - i - 1) != 0) && formatted {
				rep += " "
			}
		}
		return rep
	}
	// 強制轉為UInt32
	public func toUInt32() -> UInt32 {
		if let a = self as? UInt32 {
			return a
		} else {
			let bitRepresentation = self.bitRep()
			let bitRepCount = bitRepresentation.characters.count
			if bitRepCount > 32 {
				let range = bitRepresentation.characters.startIndex.advancedBy(bitRepCount - 32)..<bitRepresentation.characters.startIndex.advancedBy(bitRepCount)
				let text = String(bitRepresentation.characters[range])
				return UInt32.init(text, radix: 2)!
			} else if self is Int32 || self is Int16  || self is Int8 {
				let text = bitRepresentation.characters.first == "1" ? "0" + String(bitRepresentation.characters.dropFirst()) : bitRepresentation
				return UInt32.init(text, radix: 2)!
			} else {
				return UInt32.init(bitRepresentation, radix: 2)!
			}
		}
	}
	// 亂數產生  (產生範圍 0..<self)
	public func rand() -> BitFormRepresentable {
		return arc4random_uniform(self.toUInt32())
	}
}

extension Int {
	public func format(f: String) -> String {
		return String(format: "%\(f)d", self)
	}
}

extension Double {
	public func format(f: String) -> String {
		return String(format: "%\(f)f", self)
	}
}

