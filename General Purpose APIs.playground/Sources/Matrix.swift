import Foundation
public struct Matrix<Element: SummableMultipliable>: CollectionType {
	public static var emptyMatrix: Matrix<Element> {
		return Matrix<Element>(rows: 0, columns: 0, fromArray: [Element]())!
	}
	public typealias Index = Int
	public var grid: Array<Element>
	public var rows: Int
	public var columns: Int
	public var size: Int {
		return rows * columns
	}
	public var representative: [Array<Element>] {
		get {
			return getRepresentative()
		}
		set {
			guard !newValue.isEmpty else { fatalError("Assign newValue falure.") }
			let _columns = newValue[0].count
			let eqCol_in_Row: Bool = newValue.flatMap{ $0.count == _columns }.reduce(true){ $0 && $1 }
			guard eqCol_in_Row else { fatalError("newValue is not a valid matrixLiteral.") }
			let _rows = newValue.count
			guard columns == _columns && rows == _rows else { fatalError("newValue is not a valid matrixLiteral.") }
			self.grid = newValue.reduce([]){ $0 + $1 }
		}
	}
	public func getRepresentative() -> [Array<Element>] {
		guard grid.count == rows * columns else { fatalError("Not a valid matrix.") }
		let matrixRow = Array<Element>(count: columns, repeatedValue: grid[0])
		var matrix = [Array<Element>](count: rows, repeatedValue: matrixRow)
		for c in 0..<grid.count {
			let i = c / columns
			let j = c % columns
			matrix[i][j] = grid[c]
		}
		return matrix
	}
	public func transformToArray2D() -> Array2D<Element> {
		guard grid.count == rows * columns else { fatalError("Not a valid matrix.") }
		var arr2D = Array2D(rows: rows, columns: columns, initialValue: Element())
		for c in 0..<grid.count {
			let i = c / columns
			let j = c % columns
			arr2D[i, j] = grid[c]
		}
		return arr2D
	}
	public init() {
		self.grid = Array<Element>()
		self.rows = 0
		self.columns = 0
	}
	public var startIndex: Int {
		return grid.startIndex
	}
	public var endIndex: Int {
		return grid.endIndex
	}
	public subscript (index: Int) -> Element {
		get {
			return grid[index]
		}
		set {
			grid[index] = newValue
		}
	}
	public subscript (rowStr: String) -> [Element]? {
		get {
			if let row = Int(rowStr) {
				return representative[row]
			}
			return nil
		}
		set {
			if let row = Int(rowStr) {
				representative[row] = newValue!
			}
			
		}
	}
	public subscript (subRange: Range<Int>) -> ArraySlice<Element> {
		get {
			return grid[subRange]
		}
		set {
			grid[subRange] = newValue
		}
	}
	public func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	public subscript(row: Int, column: Int) -> Element {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return grid[(row * columns) + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			grid[(row * columns) + column] = newValue
		}
	}
}
extension Matrix: ArrayLiteralConvertible {
	/// Create an instance containing `elements`.
	public init(arrayLiteral elements: Element...) {
		self.grid = elements
		self.rows = 1
		self.columns = elements.count
	}
}
extension Matrix {
	public typealias Generator = IndexingGenerator<Matrix>
	public mutating func replaceRange<C: CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Int>, with newElements: C) {
		
	}
	public init(size_mxn size: Int, repeatedValue: Element) {
		self.grid = [Element](count: size, repeatedValue: repeatedValue)
		self.rows = 1
		self.columns = grid.count
	}
	public init(rows: Int, columns: Int, repeatedValue: Element) {
		self.rows = rows
		self.columns = columns
		self.grid = [Element](count: rows * columns, repeatedValue: repeatedValue)
	}
	public init?(rows: Int, columns: Int, fromArray: [Element]) {
		guard fromArray.count == rows * columns else { fatalError("size is not valid") }
		self.rows = rows
		self.columns = columns
		grid = fromArray
	}
	public init?(matrixLiteral: [[Element]]) {
		guard !matrixLiteral.isEmpty else {
			self.init()
			return
		}
		let _columns = matrixLiteral[0].count
		let eqCol_in_Row: Bool = matrixLiteral.flatMap{ $0.count == _columns }.reduce(true){ $0 && $1 }
		guard eqCol_in_Row else { fatalError("Not a valid matrixLiteral.") }
		let _rows = matrixLiteral.count
		let grid = matrixLiteral.reduce([]){ $0 + $1 }
		self.init(rows: _rows, columns: _columns, fromArray: grid)
	}
	public init?(matrixLiteral: [Element]...) {
		var matrix = [[Element]]()
		for array in matrixLiteral {
			matrix.append(array)
		}
		self.init(matrixLiteral: matrix)
	}
	public init?(rows: Int, columns: Int, matrixLiteral: [[Element]]) {
		guard rows == matrixLiteral.count && columns == matrixLiteral[0].count else {
			fatalError("Number of rows and/or columns is not match the corresponding matrixLiteral.")
		}
		self.rows = rows
		self.columns = columns
		self.grid = matrixLiteral.reduce([]){ $0 + $1 }
	}
	// Transpose
	public func getTranspose() -> Matrix<Element> {
		guard !self.isEmpty else { return self }
		var transpose = Matrix(rows: self.columns, columns: self.rows, fromArray: self.grid)!
		for i in 0..<self.rows {
			for j in 0..<self.columns {
				transpose[j,i] = self[i,j]
			}
		}
		return transpose
	}
}

extension Matrix: CustomStringConvertible {
	public var description: String {
		if rows * columns != 0 {
			return "Matrix: \(rows) x \(columns)\t" + representative.description
		}
		return "Matrix: \(rows) x \(columns)\t"
	}
}

// Equatable
public func == <T: SummableMultipliable>(lhs:Matrix<T>, rhs:Matrix<T>) -> Bool {
	return lhs.columns == rhs.columns && lhs.rows == rhs.rows && lhs.grid == rhs.grid
}

extension Matrix: Equatable { }

// Addition
public func + <T: SummableMultipliable>(lhs:Matrix<T>, rhs:Matrix<T>) -> Matrix<T> {
	guard lhs.columns == rhs.columns && lhs.rows == rhs.rows else { fatalError("These two matrix can't be added due to the size is not the same.") }
	var matrix = lhs
	for i in 0..<matrix.rows {
		for j in 0..<matrix.columns {
			matrix[i, j] += rhs[i, j]
		}
	}
	return matrix
}
// Subtraction
public func - <T: SummableMultipliable>(lhs:Matrix<T>, rhs:Matrix<T>) -> Matrix<T> {
	guard lhs.columns == rhs.columns && lhs.rows == rhs.rows else { fatalError("These two matrix can't be added due to the size is not the same.") }
	var matrix = lhs
	for i in 0..<matrix.rows {
		for j in 0..<matrix.columns {
			matrix[i, j] -= rhs[i, j]
		}
	}
	return matrix
}

public func += <T: SummableMultipliable>(inout lhs:Matrix<T>, rhs:Matrix<T>) {
	lhs = lhs + rhs
}
public func -= <T: SummableMultipliable>(inout lhs:Matrix<T>, rhs:Matrix<T>) {
	lhs = lhs - rhs
}

// Transpose
postfix operator -| {}
public postfix func -| <T: SummableMultipliable>(lhs: Matrix<T>) -> Matrix<T> {
	return lhs.getTranspose()
}

// Scalar multiplication
public func * <T: SummableMultipliable>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
	let newGrid = rhs.grid.map{ lhs * $0 }
	return Matrix(rows: rhs.columns, columns: rhs.rows, fromArray: newGrid)!
}
public func *= <T: SummableMultipliable>(inout lhs: Matrix<T>, rhs: T) {
	lhs = rhs * lhs
}

// Matrix multiplication
public func × <T: SummableMultipliable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>? {
	//A: m x l  , B: l x n, C: m x n, cij = ai1b1j + ai2b2j + ... + ailblj
	let m = lhs.rows
	let l = lhs.columns
	let n = rhs.columns
	guard !lhs.isEmpty && !rhs.isEmpty else { return nil }				// check A, B is not empty
	guard !lhs["0"]!.isEmpty && !rhs["0"]!.isEmpty else { return nil }	// check A sub, B sub is not empty
	guard lhs.columns == rhs.rows else { return nil }					// check A columns and B rows is same l.
	for element in lhs.representative {
		if element.count != l { return nil }									// check each A row has same columns
	}
	for element in rhs.representative {
		if element.count != n { return nil }									// chech each B row has same columns
	}
	var matrix = Matrix(rows: m, columns: n, repeatedValue: T())
	for i in 0..<m {
		for j in 0..<n {
			for k in 0..<l {
				matrix[i, j] += lhs[i, k] * rhs[k, j]
			}
		}
	}
	return matrix
}
public func matrixMultiplication<T: SummableMultipliable>(aMatrix: Matrix<T>, _ bMatrix: Matrix<T>) -> Matrix<T>? {
	return aMatrix × bMatrix
}

public func * <T: SummableMultipliable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>? {
	return lhs × rhs
}

public func matrix_chain_multiplication<T: SummableMultipliable>(matrixes: [Matrix<T>]) -> Matrix<T>? {
	guard matrixes.count > 1 else { return nil }
	var result: Matrix<T>? = matrixes[0]
	let remainings = matrixes[1..<matrixes.count]
	for matrix in remainings {
		if let ans = result {
			result = ans × matrix
		}
	}
	return result
}
public func matrix_chain_multiplication<T: SummableMultipliable>(matrixes: Matrix<T>...) -> Matrix<T>? {
	return matrix_chain_multiplication(matrixes)
}

public func min_matrix_chain_multiplication<T: SummableMultipliable>(matrixes: [Matrix<T>]) -> Matrix<T>? {
	let m: ([Matrix<T>]) -> Matrix<T>? = min_matrix_chain_multiplication
	guard !matrixes.isEmpty else { return nil }
	guard matrixes.count > 1 else { return matrixes[0] }
	guard matrixes.count > 2 else { return matrixes[0] * matrixes[1] }
	guard matrixes.count > 3 else {
		let a = matrixes[0].rows, b = matrixes[1].rows, c = matrixes[2].rows, d = matrixes[2].columns
		let forward = a * b * c + a * c * d
		if forward == min(a * b * c + a * c * d, a * b * d + b * c * d) {
			return m(Array(matrixes[0..<2]))! × matrixes[2]
		} else {
			return matrixes[0] × m(Array(matrixes[1..<3]))!
		}
	}
	let mid = Array(matrixes[1..<matrixes.count - 1])
	return m([matrixes[0],min_matrix_chain_multiplication(mid)!,matrixes[matrixes.count - 1]])
}

public func min_matrix_chain_multiplication<T: SummableMultipliable>(matrixes:  Matrix<T>...) ->  Matrix<T>? {
	return min_matrix_chain_multiplication(matrixes)
}

// performance evaluation functions.
public func solvingTimeInterval<T>(parameters: [T], problemBlock: ([T]) -> T?) -> Double {
	let start = NSDate() // <<<<<<<<<< Start time
	_ = problemBlock(parameters)
	let end = NSDate()   // <<<<<<<<<<   end time
	let timeInterval: Double = end.timeIntervalSinceDate(start) // <<<<< Difference in seconds (double)
	print("Time to evaluate problem : \(timeInterval) seconds")
	return timeInterval
}
public func timeElapsedInSecondsWhenRunningCode(operation:()->()) -> Double {
	let startTime = CFAbsoluteTimeGetCurrent()
	operation()
	let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
	print("Time elapsed: \(timeElapsed) seconds")
	return Double(timeElapsed)
}

