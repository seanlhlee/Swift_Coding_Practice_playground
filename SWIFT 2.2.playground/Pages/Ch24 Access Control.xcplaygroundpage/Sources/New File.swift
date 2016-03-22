import Foundation

public struct TrackedString1 {
	private(set) var numberOfEdits = 0
	public var value: String = "" {
		didSet {
			numberOfEdits += 1
		}
	}
	public init (numberOfEdits: Int, value: String) {
		self.numberOfEdits = numberOfEdits
		self.value = value
	}
	public func numberOfEditsOfStringToEdit1() -> Int {
		return numberOfEdits
	}
}


public struct TrackedString2 {
	public private(set) var numberOfEdits = 0
	public var value: String = "" {
		didSet {
			numberOfEdits += 1
		}
	}
	public init() {}
}

public protocol Xyz {
	var xyz: String {get set}
}