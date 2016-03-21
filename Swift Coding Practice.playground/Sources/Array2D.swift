import Foundation

public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	private var array: [T]
	
	public init(columns: Int, rows: Int, initialValue: T) {
		self.columns = columns
		self.rows = rows
		array = .init(count: rows*columns, repeatedValue: initialValue)
	}
	
	public subscript(column: Int, row: Int) -> T {
		get {
			return array[row*columns + column]
		}
		set {
			array[row*columns + column] = newValue
		}
	}
}