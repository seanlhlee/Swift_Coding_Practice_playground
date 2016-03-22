import Foundation

public class Node<T: Equatable>: CustomStringConvertible {
	public var name: String
	public var value: T
	public var visited: Bool = false
	private var connects = [Node<T>]()
	public init(name: String,value: T) {
		self.name = name
		self.value = value
	}
	public var description: String {
		return self.name + ":\(self.value)"
	}
	public func getConn() -> [Node] {
		return self.connects
	}
	public func addNeighbor(node: Node...) {
		for i in 0..<node.count {
			self.connects.append(node[i])
			node[i].connects.append(self)
		}
	}
}