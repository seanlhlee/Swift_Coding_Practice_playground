/*:
[Previous](@previous)
****
*/
import UIKit

let emptyMatrix = Matrix<Int>.emptyMatrix
emptyMatrix.isEmpty

//let dummyMayrix = Matrix(rows: 2, columns: 3, fromArray: [Int]())   // <------- failure check

var a = [1,2,3,4,5,6]
a.dropFirst()
a.visualizeView()
var aMatrix = Matrix(rows: 2, columns: 3, fromArray: a)!
aMatrix.visualizeView()
aMatrix.visualizeView(row: 1)
aMatrix.visualizeView(column: 1)
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


aMatrix
let b = [6,4,5,6,2,1]
var rhs = Matrix(rows: 2, columns: 3, fromArray: b)!
aMatrix - rhs

aMatrix += rhs
aMatrix -= rhs

rhs["0"] = [1,2,3]
rhs["1"] = [3,2,1]


rhs.representative
rhs-|.representative


let cMatrix = 3 * rhs
cMatrix
rhs *= 3

cMatrix == rhs



var ma = Matrix(rows: 2, columns: 3, fromArray: [0,0,3,1,2,0])!
var mb = Matrix(rows: 3, columns: 2, fromArray: [4,1,3,1,2,1])!
ma × mb
mb × ma


let amatrix = Matrix<Double>(matrixLiteral: [[9.0, 7, 1], [5, 6, 7], [5, 5, 6], [5, 6, 1]])!
let bmatrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 1, 2, 1], [2, 3, 4, 5, 6, 7], [3, 4, 4, 5, 5, 6]])!
let cmatrix = Matrix<Double>(matrixLiteral: [[1, 1], [2, 3], [3, 4], [2, 3], [2, 3], [2, 4]])!
let dmatrix = Matrix<Double>(matrixLiteral: [[1, 1, 1], [2, 3, 4]])!
let ematrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 2], [2, 3, 4, 3], [3, 4, 4, 1]])!

(((amatrix × bmatrix)! × cmatrix)! × dmatrix)! × ematrix
matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)
min_matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)


solvingTimeInterval([amatrix, bmatrix, cmatrix, dmatrix, ematrix], problemBlock: matrix_chain_multiplication)
solvingTimeInterval([amatrix, bmatrix, cmatrix, dmatrix, ematrix], problemBlock: min_matrix_chain_multiplication)

/*:
****
[Next](@next)
*/