import Foundation

public struct Queue<T> {
	private var array = [T]()
	
	public var count: Int {
		return array.count
	}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public mutating func enqueue(element: T) {
		array.append(element)
	}
	
	public mutating func dequeue() -> T? {
		if count == 0 {
			return nil
		} else {
			return array.removeFirst()
		}
	}
	
	public func peek() -> T? {
		return array.first
	}
	
	public init(array: [T]) {
		self.array = array
	}
	
	public subscript(index: Int) -> T {
		return array[index]
	}
	
}