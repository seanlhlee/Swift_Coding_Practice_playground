import Foundation

//數值形式之字面量
public protocol DoubleRepresentable { func toDouble() -> Double }
public typealias Computable = DoubleRepresentable

extension UInt: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Int8: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension UInt8: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Int16: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension UInt16: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Int32: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension UInt32: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Int64: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension UInt64: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Int: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Float: DoubleRepresentable { public func toDouble() -> Double { return Double(self) } }
extension Double: DoubleRepresentable { public func toDouble() -> Double { return self } }

// turn into COmplex
public extension DoubleRepresentable {
	public func toComplex() -> Complex<Double> {
		let re = self.toDouble()
		let im = 0.0
		return Complex<Double>(t: (re,im))
	}
}

public protocol SummableMultipliable: Comparable, DoubleRepresentable {
	init()
	func +(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	func /(lhs: Self, rhs: Self) -> Self
	prefix func -(rhs: Self) -> Self
	func +=(inout lhs: Self, rhs: Self)
	func -=(inout lhs: Self, rhs: Self)
	func *=(inout lhs: Self, rhs: Self)
}
extension Int: SummableMultipliable {}
extension Double: SummableMultipliable {}
//public func + (lhs: Computable, rhs: Computable) -> Computable {
//	return lhs.self + rhs.self
//}
//public func - (lhs: Computable, rhs: Computable) -> Computable {
//	return lhs.self - rhs.self
//}



/// extensions for struc Complex
public extension SummableMultipliable {
	public var i:Complex<Self>{
		return Complex(t: (Self(),self))
	}
	public init<U:SummableMultipliable>(_ x:U) {
		switch x {
		case let s as Self:     self.init(s)
		case let d as Double:   self.init(d)
		case let i as Int:      self.init(i)
		default:
			fatalError("init(\(x)) failed")
		}
	}
	public var isPositive: Bool {
		return self >= Self()
	}
	public func toInt() -> Int {
		switch self {
		case _ as Double:	return Int(self as! Double)
		case _ as Int:		return Int(self as! Int)
		default:
			fatalError("transform divider fail")
		}
	}
	public func toDouble() -> Double {
		switch self {
		case _ as Double:	return Double(self as! Double)
		case _ as Int:		return Double(self as! Int)
		default:
			fatalError("transform divider fail")
		}
	}
}


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



// formationg the representatiing string of an integer or a double number.
public extension Int {
	public func format(f: String) -> String {
		return String(format: "%\(f)d", self)
	}
}

public extension Double {
	public func format(f: String) -> String {
		return String(format: "%\(f)f", self)
	}
}
