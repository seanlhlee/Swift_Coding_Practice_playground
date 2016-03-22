/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 物件導向

### 請寫出一個具有加減乘除運算的複數物件？ (Complex, add, sub, mul, div) (除法可以不寫，算加分題)
*/
import Foundation
struct Complex {
	var real: Double
	var image: Double
	var description: String {
		return image >= 0 ? "\(real) + \(image)i" : "\(real) - \(-image)i"
	}
}

func + (lhs: Complex, rhs: Complex) -> Complex {
	return Complex(real: lhs.real + rhs.real, image: lhs.image + rhs.image)
}
func - (lhs: Complex, rhs: Complex) -> Complex {
	return Complex(real: lhs.real - rhs.real, image: lhs.image - rhs.image)
}
func * (lhs: Complex, rhs: Complex) -> Complex {
	let real = lhs.real * rhs.real - lhs.image * rhs.image
	let image = lhs.real * rhs.image + rhs.real * lhs.image
	return Complex(real: real, image: image)
}
func / (lhs: Complex, rhs: Complex) -> Complex {
	let com = rhs.real * rhs.real + rhs.image * rhs.image
	let reciprocal_rhs = Complex(real: rhs.real / com  , image: -rhs.image / com)
	return lhs * reciprocal_rhs
}


let a = Complex(real: 6, image: -8)
let b = Complex(real: 7, image: 8)
let addR = a + b
addR.description
let subR = a - b
subR.description
let mulR = a * b
mulR.description
let divR = a / b
divR.description
/*:
### 請寫出一個具有加、減、內積、反向運算的向量物件？ (Vector, add, sub, dot, neg)
*/
struct Vector {
	var i: Double
	var j: Double
	var k: Double
	var description: String {
		return (i >= 0 ? "\(i) i" : "\(i) i") + (j >= 0 ? " + \(j) j" : " - \(-j) j") + (k >= 0 ? " + \(k) k" : " - \(-k) k")
	}
}
func + (lhs: Vector, rhs: Vector) -> Vector {
	return Vector(i: lhs.i + rhs.i, j: lhs.j + rhs.j, k: lhs.k + rhs.k)
}
func - (lhs: Vector, rhs: Vector) -> Vector {
	return Vector(i: lhs.i - rhs.i, j: lhs.j - rhs.j, k: lhs.k - rhs.k)
}
infix operator .. {}
func .. (lhs: Vector, rhs: Vector) -> Double {
	return lhs.i * rhs.i + lhs.j * rhs.j + lhs.k * rhs.k
}
prefix func - (vector: Vector) -> Vector {
	return Vector(i: -vector.i, j: -vector.j, k: -vector.k)
}



let vector_a = Vector(i: 3, j: 6, k: 9)
let vector_b = Vector(i: 2.5, j: 7, k: 2.8)
let addV = vector_a + vector_b
addV.description
let subV = vector_a - vector_b
subV.description
let dotV = vector_a .. vector_b
let negV = -vector_a
negV.description


/*:
### 請寫一組物件，包含《矩形、圓形》與抽象的形狀，每個物件都具有 area() 函數可以計算其面積？ (Shape.area(), Rectangle, Circle)
*/
protocol Shape {
	func area() -> Double
}
struct Point {
	var x: Double
	var y: Double
}
struct Rectangle: Shape {
	var	origin: Point
	var width: Double
	var height: Double
	var center: Point {
		get {
			return Point(x: origin.x + width / 2, y: origin.y + height / 2)
		}
		set {
			origin.x = newValue.x - width / 2
			origin.y = newValue.y - height / 2
		}
	}
	func area() -> Double {
		return width * height
	}
}
struct Circle: Shape {
	var center: Point
	var radius: Double
	var diameter: Double {
		get {
			return 2 * radius
		}
		set {
			radius = newValue / 2
		}
	}
	func area() -> Double {
		return M_PI * radius * radius
	}
}

let r1 = Rectangle(origin: Point(x: 0, y: 0), width: 3, height: 6)
r1.area()
let c1 = Circle(center: Point(x: 0, y: 0), radius: 3)
c1.area()
/*:
### 電腦隨機產生一個 n*n 的二維布爾值陣列。用程式檢驗該二維字元陣列中，縱行、橫列及兩條對角線，「O(true)的bingo線」及「X(false)的bingo線」分別有多少條。

input：一個隨機產生的尺寸 n*n 之二維 Boolean 陣列

output：兩個 integers 。
*/
public enum MatrixLineType {
	case Column
	case Row
	case Diagonal_LR  //由左上往右下
	case Diagonal_RL  //由右上往左下
}

public struct Matrix2D_nBYn<T> {
	public let n: Int
	public var columns: Int { return n }
	public var rows: Int { return n }
	private var matrix: [[T]]
	
	public init(n: Int, initialValue: T) {
		self.n = n
		let array = [T].init(count: n, repeatedValue: initialValue)
		matrix = .init(count: n, repeatedValue: array)
	}
	public subscript(column: Int, row: Int) -> T {
		get {
			return matrix[column][row]
		}
		set {
			matrix[column][row] = newValue
		}
	}
	public subscript(line: MatrixLineType, number:  Int) -> [T] {
		get {
			switch line {
			case .Column:
				return matrix[number]
			case .Row:
				var array = [T]()
				for i in 0..<n {
					array.append(matrix[i][number])
				}
				return array
			case .Diagonal_LR:
				var array = [T]()
				for i in 0..<n {
					array.append(matrix[i][i])
				}
				return array
			case .Diagonal_RL:
				var array = [T]()
				for i in 0..<n {
					array.append(matrix[i][n - 1 - i])
				}
				return array
			}
		}
	}
}

var matrix = Matrix2D_nBYn(n: 5, initialValue: 0)
matrix[0,0] = 00; matrix[0,1] = 01; matrix[0,2] = 02; matrix[0,3] = 03; matrix[0,4] = 04
matrix[1,0] = 05; matrix[1,1] = 06; matrix[1,2] = 07; matrix[1,3] = 08; matrix[1,4] = 09
matrix[2,0] = 10; matrix[2,1] = 11; matrix[2,2] = 12; matrix[2,3] = 13; matrix[2,4] = 14
matrix[3,0] = 15; matrix[3,1] = 16; matrix[3,2] = 17; matrix[3,3] = 18; matrix[3,4] = 19
matrix[4,0] = 20; matrix[4,1] = 21; matrix[4,2] = 22; matrix[4,3] = 23; matrix[4,4] = 24
matrix.matrix
matrix[MatrixLineType.Column, 2]
matrix[MatrixLineType.Row, 3]
matrix[MatrixLineType.Diagonal_LR, 0]
matrix[MatrixLineType.Diagonal_RL, 0]



// 產生 3 * 3 到 8 * 8 的矩陣
func boolMatrixGenerator() -> Matrix2D_nBYn<Bool> {
	let n = 3 + Int(arc4random() % 6)
	var matrix = Matrix2D_nBYn(n: n, initialValue: true)
	for i in 0..<n {
		for j in 0..<n {
			matrix[i,j] = (arc4random() % 2 == 0)
		}
	}
	return matrix
}
func bingoCount(generator: () -> Matrix2D_nBYn<Bool>) -> (O: Int, X: Int) {
	var oCount = 0, xCount = 0
	let matrix = generator()
	matrix.matrix
	let n = matrix.n
	for i in 0..<n {
		for j in 0..<2 {
			let line = j % 2 == 0 ? matrix[MatrixLineType.Column, i] : matrix[MatrixLineType.Row, i]
			if (line.reduce(true){ $0 && $1 }) {
				++oCount
			} else if !(line.reduce(false){ $0 || $1 }) {
				++xCount
			}
		}
	}
	for k in 0..<2 {
		let line = k % 2 == 0 ? matrix[MatrixLineType.Diagonal_LR, 0] : matrix[MatrixLineType.Diagonal_RL, 0]
		if (line.reduce(true){ $0 && $1 }) {
			++oCount
		} else if !(line.reduce(false){ $0 || $1 }) {
			++xCount
		}
	}
	return (O: oCount, X: xCount)
}

let count = bingoCount(boolMatrixGenerator)


var boolMatrix = boolMatrixGenerator()
boolMatrix.matrix



/*:
****
[Next](@next)
*/
