import Foundation
/// `NodeP` confirm to `Equatable` for checking the previous existance of present node to prevent double invitations for being a new node.
public class NodeP<T: Equatable>: CustomStringConvertible, Equatable {
	/// name of the node.
	private(set) public var name: String
	/// value of the node, normally the value should be no repeated with the values of the other nodes.
	private(set) public var value: T
	/// A boolean value to indicate the node is visitable. (True for no additational visit)
	public var visited: Bool = false
	private var childNodes = [NodeP<T>]()					// Nodes can be visited directly form present node.
	private var parentNodes = [NodeP<T>]()					// The nodes from where can visit present node directly.
	/// Initializer
	public init(name: String,value: T) {
		self.name = name
		self.value = value
	}
	/// Simple description. Comformance of 'CustomStringConvertible'.
	public var description: String {
		return self.name + ":\(self.value)"
	}
	/// Get the child nodes list.
	public func getChild() -> [NodeP<T>] {
		return self.childNodes
	}
	/// Add a child node to present node.
	private func addChild(node: NodeP<T>) -> Bool{
		guard node.parentNodes.isEmpty else { return false } //如果已經有parent就不加入此子結點
		guard node.childNodes.isEmpty else { return false } //如果已經有parent就不加入此子結點
		for child in childNodes {
			guard node != child else { return false }
		}
		for parent in parentNodes {
			guard node != parent else { return false }
		}
		self.childNodes.append(node)
		node.parentNodes.append(self)
		return true
	}
	/// Add child nodes to present node.
	public func addChild(nodes: NodeP<T>...) {
		for node in nodes {
			if !addChild(node) {
				print("Fail to add \(node.name) to \(self.name).")
			}
		}
	}
}
/// Comformace of 'Equatable'.
public func ==<T> (lhs: NodeP<T>, rhs: NodeP<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.name == rhs.name else { return false }
	return true
}
public func !=<T> (lhs: NodeP<T>, rhs: NodeP<T>) -> Bool {
	return !(lhs == rhs)
}