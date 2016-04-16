/*:
[Previous](@previous)
****
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


/*
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
*/
let amatrix = Matrix<Double>(matrixLiteral: [[9.0, 7, 1], [5, 6, 7], [5, 5, 6], [5, 6, 1]])!
let bmatrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 1, 2, 1], [2, 3, 4, 5, 6, 7], [3, 4, 4, 5, 5, 6]])!
let cmatrix = Matrix<Double>(matrixLiteral: [[1, 1], [2, 3], [3, 4], [2, 3], [2, 3], [2, 4]])!
let dmatrix = Matrix<Double>(matrixLiteral: [[1, 1, 1], [2, 3, 4]])!
let ematrix = Matrix<Double>(matrixLiteral: [[1, 3, 1, 2], [2, 3, 4, 3], [3, 4, 4, 1]])!

let solutionA = (((amatrix × bmatrix)! × cmatrix)! × dmatrix)! × ematrix
let solutionB = matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)
let solutionC = min_matrix_chain_multiplication(amatrix, bmatrix, cmatrix, dmatrix, ematrix)


solvingTimeInterval([amatrix, bmatrix, cmatrix, dmatrix, ematrix], problemBlock: matrix_chain_multiplication)
solvingTimeInterval([amatrix, bmatrix, cmatrix, dmatrix, ematrix], problemBlock: min_matrix_chain_multiplication)


solutionA?.visualizeView()
solutionB?.visualizeView()
solutionC?.visualizeView()


/*:
可以調整成 online 版本。

	for (int k=1; k<N; ++k)
		for (int i=k-1; i>=0; --i)
			for (int j=k-1; j>=i; --j)
	//      for (int j=i; j<k; ++j)
				f[i][k] = min(f[i][k], f[i][j] + f[j+1][k] + r[i] * c[j] * c[k]);
*/
// ToDo Swift Code
/*:
想要印出矩陣相乘的順序，另外用一個陣列，紀錄最後一次的相乘位置。

[348]:http://uva.onlinejudge.org/external/3/348.html ""
[442]:http://uva.onlinejudge.org/external/4/442.html ""
[6669]:https://icpcarchive.ecs.baylor.edu/external/66/6669.pdf ""
_____________________
UVa [348], UVa [442], ICPC [6669]
****
[Next](@next)
*/
