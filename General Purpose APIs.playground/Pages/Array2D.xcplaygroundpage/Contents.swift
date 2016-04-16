/*:
[Previous](@previous)
****
# Array2D<T>
 Array2D<T> provides an initializer that takes two parameters called rows and columns, and creates an array that is large enough to store rows * columns values of type <T>.

 Each position in the matrix is given an initial value of initialValue were given while initialize. To achieve this, the array’s size, and an initial cell value of initialValue, are passed to an array initializer that creates and initializes a new array of the correct size.
*/
import Foundation

/// Array2D<T> provides an initializer that takes two parameters called rows and columns, and creates an array that is large enough to store rows * columns values of type <T>.
/// Each position in the matrix is given an initial value of initialValue were given while initialize. To achieve this, the array’s size, and an initial cell value of initialValue, are passed to an array initializer that creates and initializes a new array of the correct size.

public struct Array2D<T> {
	public let columns: Int
	public let rows: Int
	var array: [T]
	
	public init(rows: Int, columns: Int, initialValue: T) {
		self.columns = columns
		self.rows = rows
		array = .init(count: rows*columns, repeatedValue: initialValue)
	}
	func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	func indexIsValid(row: Int, range: Range<Int>) -> Bool {
		return _indexIsValid(row...row, colRange: range)
	}
	func indexIsValid(range: Range<Int>, column: Int) -> Bool {
		return _indexIsValid(range, colRange: column...column)
	}
	func _indexIsValid(rowRange: Range<Int>? ,colRange: Range<Int>?) -> Bool {
		let rows: Range<Int> = rowRange != nil ? rowRange! : rowIndices
		let cols: Range<Int> = colRange != nil ? colRange! : colIndices
		return rows.startIndex >= 0 && rows.endIndex <= self.rows && cols.startIndex >= 0 && cols.endIndex <= self.columns
	}
	public subscript(row: Int,column: Int) -> T {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return array[row*columns + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			array[row*columns + column] = newValue
		}
	}
}

public extension Array2D {
	var colIndices: Range<Int> {
		return 0..<self.columns
	}
	var rowIndices: Range<Int> {
		return 0..<self.rows
	}
	/// get elements in a row
	public subscript(row: Int,range: Range<Int>?) -> [T] {
		let r: Range<Int> = range != nil ? range! : colIndices
		guard indexIsValid(row, range: r) else {
			fatalError("Index out of range")
		}
		var array = [T]()
		r.forEach{ array.append(self[row, $0]) }
		return array
	}
	/// get elements in a column
	public subscript(range: Range<Int>?, column: Int) -> [T] {
		let r: Range<Int> = range != nil ? range! : rowIndices
		guard indexIsValid(r, column: column) else {
			fatalError("Index out of range")
		}
		var array = [T]()
		r.forEach{ array.append(self[$0, column]) }
		return array
	}
}
import UIKit



var a = Array2D(rows: 3, columns: 5, initialValue: 0)
for i in a.rowIndices {
	for j in a.colIndices {
		a[i,j] = i*a.columns + j
	}
}



let colIndices = a.colIndices
let rowIndices = a.rowIndices
a[0, colIndices]
a[rowIndices,1]
a[1, 2...4]
a[0..<3, 2]
a[nil, 3]
a[2, nil]

extension Array2D {
	func getIndices(row row: Int) -> [Int]  {
		return _getIndices(row...row, colRange: nil)
	}
	func getIndices(column col: Int) -> [Int]  {
		return _getIndices(nil, colRange: col...col)
	}
	func getIndices(row row: Int, col: Int) -> [Int]  {
		return _getIndices(row...row, colRange: col...col)
	}
	private func _getIndices(rowRange: Range<Int>? ,colRange: Range<Int>?) -> [Int] {
		guard _indexIsValid(rowRange, colRange: colRange) else { fatalError("Index out of range") }
		let rows: Range<Int> = rowRange != nil ? rowRange! : rowIndices
		let cols: Range<Int> = colRange != nil ? colRange! : colIndices
		var array = [Int]()
		for row in rows {
			for col in cols {
				array.append(row * columns + col)
			}
		}
		return array
	}
}

a.getIndices(row: 2)
a.getIndices(column: 4)





/*:
## Application: 9 x 9 Times Table

![](timestable.png "")

*/

/// TimesTable: Print a 1 x 1 through 9 x 9 table
public func timesTable() {
	print("TimesTable 9 x 9")
	var multiplication = Array2D(rows: 9, columns: 9, initialValue: 0)
	for row in 1...9 {
		for colume in 1...9 {
			multiplication[row - 1, colume - 1] = row * colume
			print("\(row) x \(colume) = \(multiplication[row - 1, colume - 1])", terminator: colume == 9 ? "\n" : "\t")
		}
	}
}

timesTable()

/*:
****
[Next](@next)
*/