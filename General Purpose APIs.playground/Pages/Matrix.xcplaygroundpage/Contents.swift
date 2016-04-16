/*:
[Previous](@previous)
****
# Matrix
## Definition
A matrix is a rectangular array of numbers or other mathematical objects for which operations such as addition and multiplication are defined. Most commonly, a matrix over a field F is a rectangular array of scalars each of which is a member of F. Most of this article focuses on real and complex matrices, that is, matrices whose elements are real numbers or complex numbers, respectively. More general types of entries are discussed below. For instance, this is a real matrix:

![](1.png "")

The numbers, symbols or expressions in the matrix are called its entries or its elements. The horizontal and vertical lines of entries in a matrix are called rows and columns, respectively.

![](matrix.png "")

## Notation
Matrices are commonly written in box brackets or parentheses:
![](2.png)

*/


import UIKit

public protocol SummableMultipliable: Equatable {
	init()
	func +(lhs: Self, rhs: Self) -> Self
	func *(lhs: Self, rhs: Self) -> Self
	func -(lhs: Self, rhs: Self) -> Self
	func +=(inout lhs: Self, rhs: Self)
	func -=(inout lhs: Self, rhs: Self)
	func *=(inout lhs: Self, rhs: Self)
}
extension Int: SummableMultipliable {}
extension Double: SummableMultipliable {}

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


let emptyMatrix = Matrix<Int>.emptyMatrix
emptyMatrix.isEmpty

//let dummyMayrix = Matrix(rows: 2, columns: 3, fromArray: [Int]())   // <------- failure check

var a = [1,2,3,4,5,6]
a.dropFirst()
a
var aMatrix = Matrix(rows: 2, columns: 3, fromArray: a)!
aMatrix.transformToArray2D().visualizeView()
aMatrix.isEmpty
aMatrix.columns
aMatrix.rows
aMatrix.grid.count == aMatrix.rows * aMatrix.columns
aMatrix.startIndex
aMatrix.count
aMatrix[3]
aMatrix.representative
aMatrix.dropFirst()
aMatrix.last
aMatrix.underestimateCount()
aMatrix[1]
aMatrix.columns
aMatrix.representative
aMatrix[0]
aMatrix["0"] = [1,2,5]
aMatrix[0,1]

aMatrix.representative
aMatrix.representative = [[1,3,5], [2,4,6]]
aMatrix.representative


/*:
## Basic operations
There are a number of basic operations that can be applied to modify matrices, called matrix addition, scalar multiplication, transposition, matrix multiplication, row operations, and submatrix.

Addition, scalar multiplication and transposition

![](3.png)

Familiar properties of numbers extend to these operations of matrices: for example, addition is commutative, that is, the matrix sum does not depend on the order of the summands: **A** + **B** = **B** + **A**.The transpose is compatible with addition and scalar multiplication, as expressed by (c**A**)ᵀ = c(**A**ᵀ) and (**A** + **B**)ᵀ = **A**ᵀ + **B**ᵀ. Finally, (**A**ᵀ)ᵀ = **A**.

*/
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

aMatrix
let b = [6,4,5,6,2,1]
var rhs = Matrix(rows: 2, columns: 3, fromArray: b)!
aMatrix - rhs

public func += <T: SummableMultipliable>(inout lhs:Matrix<T>, rhs:Matrix<T>) {
	lhs = lhs + rhs
}
public func -= <T: SummableMultipliable>(inout lhs:Matrix<T>, rhs:Matrix<T>) {
	lhs = lhs - rhs
}

aMatrix += rhs
aMatrix -= rhs

// Transpose
postfix operator -| {}
postfix func -| <T: SummableMultipliable>(lhs: Matrix<T>) -> Matrix<T> {
	return lhs.getTranspose()
}

rhs["0"] = [1,2,3]
rhs["1"] = [3,2,1]


rhs.representative
rhs-|.representative

// Scalar multiplication
public func * <T: SummableMultipliable>(lhs: T, rhs: Matrix<T>) -> Matrix<T> {
	let newGrid = rhs.grid.map{ lhs * $0 }
	return Matrix(rows: rhs.columns, columns: rhs.rows, fromArray: newGrid)!
}
public func *= <T: SummableMultipliable>(inout lhs: Matrix<T>, rhs: T) {
	lhs = rhs * lhs
}

let cMatrix = 3 * rhs
cMatrix
rhs *= 3

cMatrix == rhs

/*:
## Matrix multiplication

![](4.png)
Schematic depiction of the matrix product **AB** of two matrices **A** and **B**.

Multiplication of two matrices is defined if and only if the number of columns of the left matrix is the same as the number of rows of the right matrix. If A is an m-by-n matrix and B is an n-by-p matrix, then their matrix product **AB** is the m-by-p matrix whose entries are given by dot product of the corresponding row of **A** and the corresponding column of **B**:

![](5.png)
where 1 ≤ i ≤ m and 1 ≤ j ≤ p.[13] For example, the underlined entry 2340 in the product is calculated as (2 × 1000) + (3 × 100) + (4 × 10) = 2340:

![](6.png)
Matrix multiplication satisfies the rules (**AB**)**C** = **A**(**BC**), and (**A**+**B**)**C** = **AC**+**BC** as well as **C**(**A**+**B**) = **CA**+**CB**, whenever the size of the matrices is such that the various products are defined. The product **AB** may be defined without **BA** being defined, namely if **A** and **B** are m-by-n and n-by-k matrices, respectively, and m ≠ k. Even if both products are defined, they need not be equal, that is, generally

**AB** ≠ **BA**

that is, matrix multiplication is not commutative, in marked contrast to (rational, real, or complex) numbers whose product is independent of the order of the factors. An example of two matrices not commuting with each other is:

![](7.png)

whereas

![](8.png)
*/

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


var ma = Matrix(rows: 2, columns: 3, fromArray: [0,0,3,1,2,0])!
var mb = Matrix(rows: 3, columns: 2, fromArray: [4,1,3,1,2,1])!
ma × mb
mb × ma
public func * <T: SummableMultipliable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Matrix<T>? {
	return lhs × rhs
}

/*:
_____________________
## 範例：矩陣相乘次序（ Matrix Chain Multiplication ）
_____________________

![](DynamicProgramming12.png "")

矩陣乘法具有結合律。一連串的矩陣乘法，從中任取兩個相鄰的矩陣相乘，先行結合成一個新矩陣，不會改變所有矩陣相乘之後的結果。

在一連串的矩陣乘法中，無論從何處開始相乘，計算結果都一樣，然而計算時間卻有差異。兩個矩陣大小為 a x b 及 b x c ，相乘需要 O(a*b*c) 時間（當然還可以更快，但是此處不討論），那麼一連串的矩陣相乘，需要多少時間呢？

![](DynamicProgramming13.png "")

原來的一連串矩陣，可以從最後一次相乘的地方分開，化作兩串矩陣相乘。考慮所有可能的分法。

![](DynamicProgramming14.png "")

int f[100][100];
int r[100], c[100];

void matrix_chain_multiplication() {
memset(array, 0x7f, sizeof(array));
for (int i=0; i<N; ++i)
array[i][i] = 0;

for (int l=1; l<N; ++l)
for (int i=0; i+l<N; ++i) {
int k = i + l;
for (int j=i; j<k; ++j)
f[i][k] = min(f[i][k], f[i][j] + f[j+1][k] + r[i] * c[j] * c[k]);
}
}
*/
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

let amatrix = Matrix<Double>(matrixLiteral: [[9.0, 7, 1], [5, 6, 7], [5, 5, 6], [5, 6, 1]])!
let bmatrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 1, 2, 1], [2, 3, 4, 5, 6, 7], [3, 4, 4, 5, 5, 6]])!
let cmatrix = Matrix<Double>(matrixLiteral: [[1, 1], [2, 3], [3, 4], [2, 3], [2, 3], [2, 4]])!
let dmatrix = Matrix<Double>(matrixLiteral: [[1, 1, 1], [2, 3, 4]])!
let ematrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 2], [2, 3, 4, 3], [3, 4, 4, 1]])!

(((amatrix × bmatrix)! × cmatrix)! × dmatrix)! × ematrix
matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)
min_matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)

/*:
****
[Next](@next)
*/