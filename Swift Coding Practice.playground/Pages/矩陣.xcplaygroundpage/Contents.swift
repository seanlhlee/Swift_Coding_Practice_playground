/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 矩陣

### 寫一個程式把矩陣轉置。

範例：transpose([[1,2,3], [3,2,1]]) => [[1,3], [2,2], [3,1]]

[參考]:http://zerojudge.tw/ShowProblem?problemid=a015 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a015
*/
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

func transpose<T>(matrix: Array2D<T>) -> Array2D<T> {
	guard !matrix.array.isEmpty else { return matrix }
	var transposeM = Array2D(columns: matrix.rows, rows: matrix.columns, initialValue: matrix[0, 0])
	for i in 0..<matrix.columns {
		for j in 0..<matrix.rows {
			transposeM[j,i] = matrix[i,j]
		}
	}
	return transposeM
}
var matrix = Array2D(columns: 2, rows: 3, initialValue: 0)
matrix[0,0] = 1; matrix[0,1] = 2; matrix[0,2] = 3
matrix[1,0] = 3; matrix[1,1] = 2; matrix[1,2] = 1
var transmatrix = transpose(matrix)
transmatrix[0,0]
transmatrix[0,1]
transmatrix[1,0]
transmatrix[1,1]
transmatrix[2,0]
transmatrix[2,1]

func transpose<T>(matrix: [[T]]) -> [[T]] {
	guard !matrix.isEmpty else { return matrix }
	let row_count = matrix.count
	let col_count = matrix[0].count
	for column in matrix {
		if column.count != col_count { return matrix }
	}
	let row = [T](count: row_count, repeatedValue: matrix[0][0])
	var transpose_matrix = [[T]](count: col_count, repeatedValue: row)
	for i in 0..<row_count {
		for j in 0..<col_count {
			transpose_matrix[j][i] = matrix[i][j]
		}
	}
	return transpose_matrix
}
let matrixX = [[1,2,3], [3,2,1]]
transpose(matrixX)

/*:
### 請寫一個函數計算兩矩陣相加？

範例： add([[1,2],[3,4]], [[1,1],[1,1]]) => [[2,3], [4,5]]
*/


func add<T: Computable>(matrixA a: [[T]], matrixB b: [[T]]) -> [[T]]? {
	guard !a.isEmpty && !b.isEmpty else { return nil }
	guard a.count == b.count else { return nil }
	let row = [T](count: a[0].count, repeatedValue: a[0][0])
	var matrix = [[T]](count: a.count, repeatedValue: row)
	for i in 0..<a.count {
		if a[i].count != b[i].count {
			return nil
		}
		for j in 0..<matrix[i].count {
			matrix[i][j] = ((a[i][j] + b[i][j]) as? T)!
		}
	}
	return matrix
}  ////泛型的做法還有問題, 需要再仔細研究
func add(matrixA a: [[Int]], matrixB b: [[Int]]) -> [[Int]]? {
	guard !a.isEmpty && !b.isEmpty else { return nil }
	guard a.count == b.count else { return nil }
	let row = [Int](count: a[0].count, repeatedValue: a[0][0])
	var matrix = [[Int]](count: a.count, repeatedValue: row)
	for i in 0..<a.count {
		if a[i].count != b[i].count {
			return nil
		}
		for j in 0..<matrix[i].count {
			matrix[i][j] = a[i][j] + b[i][j]
		}
	}
	return matrix
}

var matrixA = [[1,2],[3,4]]
var matrixB = [[1,1],[1,1]]
add(matrixA: matrixA, matrixB: matrixB)
/*:
### 請寫一個函數計算兩矩陣相減？

範例： sub([[1,2],[3,4]], [[1,1],[1,1]]) => [[0,1], [2,3]]
*/
func substrate(matrixA a: [[Int]], matrixB b: [[Int]]) -> [[Int]]? {
	guard !a.isEmpty && !b.isEmpty else { return nil }
	guard a.count == b.count else { return nil }
	let row = [Int](count: a[0].count, repeatedValue: a[0][0])
	var matrix = [[Int]](count: a.count, repeatedValue: row)
	for i in 0..<a.count {
		if a[i].count != b[i].count {
			return nil
		}
		for j in 0..<matrix[i].count {
			matrix[i][j] = a[i][j] - b[i][j]
		}
	}
	return matrix
}
substrate(matrixA: matrixA, matrixB: matrixB)
/*:
### 請寫一個函數計算兩矩陣相乘？

範例： mul([[1,2],[3,4]], [[1,1],[1,1]]) => [[3,3], [7,7]]

![](https://upload.wikimedia.org/math/0/3/a/03a587627dac6e73fd867a100c6ca9ee.png "")
![](https://upload.wikimedia.org/wikipedia/commons/2/26/Matrix_multiplication_diagram.PNG "")
![](https://upload.wikimedia.org/math/c/a/c/cac2a72fb215342115afad0140a53fcd.png "")

*/
func multiplication(matrixA a: [[Int]], matrixB b: [[Int]]) -> [[Int]]? {
	//A: m x l  , B: l x n, C: m x n, cij = ai1b1j + ai2b2j + ... + ailblj
	let m = a.count
	let l = a[0].count
	let n = b[0].count
	guard !a.isEmpty && !b.isEmpty else { return nil }			// check A, B is not empty
	guard !a[0].isEmpty && !b[0].isEmpty else { return nil }	// check A sub, B sub is not empty
	guard a[0].count == b.count else { return nil }				// check A columns and B rows is same l.
	for element in a {
		if element.count != l { return nil }					// check each A row has same columns
	}
	for element in b {
		if element.count != n { return nil }					// chech each B row has same columns
	}
	let row = [Int](count: n, repeatedValue: 0)
	var matrix = [[Int]](count: m, repeatedValue: row)
	for i in 0..<matrix.count {
		for j in 0..<matrix[i].count {
			for k in 0..<l {
				matrix[i][j] += a[i][k] * b[k][j]
			}
		}
	}
	return matrix
}
multiplication(matrixA: matrixA, matrixB: matrixB)
matrixA = [[1, 2, 3], [-1, 0, 4]]
matrixB = [[1, 2, 3, -3], [0, -1, 4, 0], [-1, 0, -2, 1]]
multiplication(matrixA: matrixA, matrixB: matrixB)

/*:
### 請寫一個函數 neg(A) 傳回某矩陣 A 的負矩陣 -A。

範例： neg([[1,2],[3,4]]) => [[-1,-2],[-3,-4]]
*/
func negtive(matrixA a: [[Int]]) -> [[Int]] {
	//負矩陣  -A:  A + (-A) = O (0矩陣)
	guard !a.isEmpty else { return a }
	let row = [Int](count: a[0].count, repeatedValue: 0)
	let matrix = [[Int]](count: a.count, repeatedValue: row)
	return substrate(matrixA: matrix, matrixB: a)!
}

matrixA = [[1,2],[3,4]]
matrixB = [[1,1],[1,1]]
var negA = negtive(matrixA: matrixA)
add(matrixA: matrixA, matrixB: negA)
/*:
### 請寫一個函數判斷某方陣是否每行每列的加總都是一樣的？

範例： isMagic([[1,2,3], [2,3,1], [3,2,1]]) = false
      isMagic([[1,2,3], [2,3,1], [3,1,2]]) = true
*/
func isMagic(matrix:[[Int]]) -> Bool {
	guard !matrix.isEmpty else { return false }
	let n = matrix[0].count
	let sum_mn = matrix[0].reduce(0){ $0 + $1 }
	for sub in matrix {
		if sub.count != n { return false }
		let check = sub.reduce(0){ $0 + $1 }
		if check != sum_mn { return false }
	}
	for j in 0..<n {
		var sumColumn = 0
		for i in 0..<matrix.count {
			sumColumn += matrix[i][j]
		}
		if sumColumn != sum_mn { return false }
	}
	return true
}
var magicMatrix = [[1,2,3], [2,3,1], [3,2,1]]
isMagic(magicMatrix)

magicMatrix = [[1,2,3], [2,3,1], [3,1,2]]
isMagic(magicMatrix)

/*:
### 請寫一個函數可以把 n*m 個數值的陣列改變為的矩陣？

範例： asMatrix([1,2,3,4,5,6], 2, 3) => [[1,2,3],[4,5,6]]
*/
enum InputError: ErrorType {
	case Negative
	case RangeErr
}
func asMatrix<T>(array: [T], n: Int, m: Int) throws -> [[T]] {
	guard array.count == n * m else { throw InputError.RangeErr }
	let matrixRow = [T](count: m, repeatedValue: array[0])
	var matrix = [[T]](count: n, repeatedValue: matrixRow)
	for c in 0..<array.count {
		let i = c / m
		let j = c % m
		matrix[i][j] = array[c]
	}
	return matrix
}
var array = [1,2,3,4,5,6]
try asMatrix(array, n: 2, m: 3)
try asMatrix(array, n: 3, m: 2)
try asMatrix(array, n: 6, m: 1)
try asMatrix(array, n: 1, m: 6)

/*:
****
[Next](@next)
*/
