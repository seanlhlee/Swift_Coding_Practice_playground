import Foundation

public class Math<T: SummableMultipliable> {
	public class func randn() -> T {
		// generate random guassian distribution number. (mean : 0, standard deviation : 1)
		var v1, v2, s: Double
		repeat {
			v1 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
			v2 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
			s = v1 * v1 + v2 * v2
		} while (s >= 1.0 || s == 0.0)
		
		s = sqrt( (-2.0 * log(s)) / s )
		let result = v1 * s
		if T() is Double {
			return result as! T
		}
		return result.toInt() as! T
	}
	public class func shape<T>(matrix: [[T]]) -> [Int] {
		return [matrix.count, matrix[0].count]
	}
	public class func addVec(vec1: [T], vec2: [T]) -> [T] {
		guard vec1.count == vec2.count else { fatalError("Length Error : not same.") }
		var result = [T]()
		for i in vec1.indices {
			result.append(vec1[i] + vec2[i])
		}
		return result
	}
	public class func minusVec(vec1: [T], vec2: [T]) -> [T] {
		guard vec1.count == vec2.count else { fatalError("Length Error : not same.") }
		var result = [T]()
		for i in vec1.indices {
			result.append(vec1[i] - vec2[i])
		}
		return result
	}
	public class func addMatScalar(mat: [[T]], scalar: T) -> [[T]] {
		return mat.map{ $0.replace(scalar, op: +) }
	}
	public class func addMatVec(mat: [[T]], vec: [T]) -> [[T]] {
		guard mat[0].count == vec.count else { fatalError("Length Error : not same.") }
		return mat.replace(vec, op: Array.add)
	}
	public class func minusMatVec(mat: [[T]], vec: [T]) -> [[T]] {
		guard mat[0].count == vec.count else { fatalError("Length Error : not same.") }
		return mat.replace(vec, op: Array.sub)
	}
	public class func addMat(mat1: [[T]], mat2: [[T]]) -> [[T]] {
		guard mat1.count == mat2.count && mat1[0].count == mat2[0].count else { fatalError("Matrix mismatch.") }
		var result = mat1
		for i in 0..<mat1.count {
			for j in 0..<mat1[0].count {
				result[i][j] += mat2[i][j]
			}
		}
		return result
	}
	public class func minusMat(mat1: [[T]], mat2: [[T]]) -> [[T]] {
		guard mat1.count == mat2.count && mat1[0].count == mat2[0].count else { fatalError("Matrix mismatch.") }
		var result = mat1
		for i in 0..<mat1.count {
			for j in 0..<mat1[0].count {
				result[i][j] -= mat2[i][j]
			}
		}
		return result
	}
	public class func transpose(mat: [[T]]) -> [[T]] {
		guard !mat.isEmpty else { return mat }
		let e = [T](count: mat.count, repeatedValue: T())
		var result = [[T]](count: mat[0].count, repeatedValue: e)
		for i in 0..<result.count {
			for j in 0..<result[0].count {
				result[i][j] = mat[j][i]
			}
		}
		return result
	}
	public class func dotVec(vec1: [T], vec2: [T]) -> T {
		guard vec1.count == vec2.count else { fatalError("Vector mismatch") }
		var result = T()
		for i in 0..<vec1.count {
			result += vec1[i] * vec2[i]
		}
		return result
	}
	public class func outerVec(vec1: [T], vec2:[T]) -> [[T]] {
		let mat1 = transpose([vec1])
		let mat2 = [vec2]
		return mulMat(mat1, mat2: mat2)
	}
	public class func mulMat(mat1: [[T]], mat2: [[T]]) -> [[T]] {
		guard mat1[0].count == mat2.count else {fatalError("Array mismatch")}
		let e = [T](count: mat2[0].count, repeatedValue: T())
		var result = [[T]](count: mat1.count, repeatedValue: e)
		let mat2_T = transpose(mat2)
		for i in 0..<result.count {
			for j in 0..<result[0].count {
				result[i][j] = dotVec(mat1[i], vec2: mat2_T[j])
			}
		}
		return result
	}
	public class func mulVecScalar(vec: [T], scalar: T) -> [T] {
		return vec.map{ $0 * scalar }
	}
	public class func mulMatScalar(mat: [[T]], scalar: T) -> [[T]] {
		return mat.map{ $0.replace(scalar, op: *) }
	}
	public class func mulMatElementWise(mat1: [[T]], mat2: [[T]]) -> [[T]] {
		guard mat1.count == mat2.count && mat1[0].count == mat2[0].count else {fatalError("Matrix shape error : not same")}
		var result = mat1
		for i in result.indices {
			for j in result[0].indices {
				result[i][j] *= mat2[i][j]
			}
		}
		return result
	}
	public class func sumVec(vec: [T]) -> T {
		return vec.reduce(T()){ $0 + $1 }
	}
	public class func sumMat(mat: [[T]]) -> T {
		return mat.flatMap{ sumVec($0) }.reduce(T()){ $0 + $1 }
	}
	public class func sumMatAxis(mat: [[T]], axis: Int = 0) -> [T] {
		// default axis 0
		// axis 0 : mean of col vector . axis 1 : mean of row vector
		if axis == 1 {
			return mat.flatMap{ sumVec($0) }
		} else {
			return transpose(mat).flatMap{ sumVec($0) }
		}
	}
	public class func meanVec(vec: [T]) -> T {
		if T() is Double {
			return sumVec(vec).toDouble() / vec.count.toDouble() as! T
		}
		return sumVec(vec) / (vec.count as! T)
	}
	public class func meanMat(mat: [[T]]) -> T {
		if T() is Double {
			return sumMat(mat).toDouble() / mat.count.toDouble() / mat[0].count.toDouble() as! T
		}
		return sumMat(mat) / (mat.count as! T) / (mat[0].count as! T)
	}
	public class func meanMatAxis(mat: [[T]], axis: Int = 0) -> [T] {
		// default axis 0
		// axis 0 : mean of col vector . axis 1 : mean of row vector
		if axis == 1 {
			return mat.flatMap{ meanVec($0) }
		} else {
			return transpose(mat).flatMap{ meanVec($0) }
		}
	}
	public class func squareVec(vec: [T]) -> [T] {
		return vec.map{ $0 * $0 }
	}
	public class func squareMat(mat: [[T]]) -> [[T]] {
		return mat.map{ squareVec($0) }
	}
	public class func minVec(vec: [T]) -> T? {
		return vec.minElement()
	}
	public class func maxVec(vec: [T]) -> T? {
		return vec.maxElement()
	}
	public class func minMat(mat: [[T]]) -> T? {
		return mat.flatMap{minVec($0)}.minElement()
	}
	public class func maxMat(mat: [[T]]) -> T? {
		return mat.flatMap{maxVec($0)}.maxElement()
	}
	public class func zeroVec(n: Int) -> [T] {
		return [T](count: n, repeatedValue: T())
	}
	public class func zeroMat(row: Int, col: Int) -> [[T]] {
		return [[T]](count: row, repeatedValue: [T](count: col, repeatedValue: T()))
	}
	public class func oneVec(n: Int) -> [T] {
		if T() is Double {
			return [T](count: n, repeatedValue: 1.toDouble() as! T)
		}
		return [T](count: n, repeatedValue: 1 as! T)
	}
	public class func oneMat(row: Int, col: Int) -> [[T]] {
		if T() is Double {
			return [[T]](count: row, repeatedValue: [T](count: col, repeatedValue: 1.toDouble() as! T))
		}
		return [[T]](count: row, repeatedValue: [T](count: col, repeatedValue: 1 as! T))
	}
	public class func randD() -> Double {
		return arc4random().toDouble() / UInt32.max.toDouble()
	}
	public class func randT() -> T {
		if T() is Double {
			return arc4random().toDouble() / UInt32.max.toDouble() as! T
		}
		return (arc4random().toDouble() / UInt32.max.toDouble()).toInt() as! T
	}
	public class func randVec(n: Int, lower: T, upper: T) -> [T] {
		let l = lower <= upper ? lower.toDouble() : upper.toDouble()
		let u = lower <= upper ? upper.toDouble() : upper.toDouble()
		let result = [Double](count: n, repeatedValue: 0)
		if T() is Double {
			return result.map{ _ in l + (u - l) * randD() as! T }
		}
		return result.flatMap{ _ in ((l + (u - l) * randD()).toInt() as! T) }
	}
	public class func randMat(row: Int, col: Int, lower: T, upper: T) -> [[T]] {
		let result = zeroMat(row, col: col)
		return result.map{ _ in randVec(col, lower: lower, upper: upper) }
	}
	public class func randnVec(n: Int, mean: T, sigma: T) -> [T] {
		let result = Array(count: n, repeatedValue: T())
		return result.map{ _ in mean + sigma * randn() }
	}
	public class func randnMat(row: Int, col: Int, mean: T, sigma: T) -> [[T]] {
		let result = zeroMat(row, col: col)
		return result.map{ _ in randnVec(col, mean: mean, sigma: sigma) }
	}
	public class func identity(n: Int) -> [[T]] {
		var result = zeroMat(n, col: n)
		for i in 0..<n {
			result[i][i] = T() is Double ? 1.0 as! T : 1.0.toInt() as! T
		}
		return result
	}
	public class func sigmoid(x: T) -> Double {
		var s = (1.0 / (1.0 + exp(-x.toDouble())))
		if(s == 1) {
			s = 0.99999999999999
		} else if(s == 0) {
			s = 1e-14
		}
		return s
	}
	public class func dSigmoid(x: T) -> Double {
		return sigmoid(x) * (1 - sigmoid(x))
	}
	public class func probToBinaryMat(mat: [[T]]) -> [[T]] {
		let one = T() is Double ? 1.0 as! T : 1.0.toInt() as! T
		let result = mat
		return result.map{ $0.map{ $0 > randT() ? one : T() } }
	}
	public class func activateVec(vec: [T], activation: (T) -> T) -> [T] {
		return vec.map{ activation($0) }
	}
	public class func activateMat(mat: [[T]], activation: (T) -> T) -> [[T]] {
		return mat.map{ $0.map{ activation($0) } }
	}
	public class func activateTwoVec(vec1: [T], vec2: [T], activation: (T, T) -> T) -> [T] {
		guard vec1.count == vec2.count else { fatalError("Matrix shape error : not same") }
		var result = vec1
		for i in vec1.indices {
			result[i] = activation(vec1[i], vec2[i])
		}
		return result
	}
	public class func activateTwoMat(mat1: [[T]], mat2: [[T]], activation: (T, T) -> T) -> [[T]] {
		guard mat1.count == mat2.count && mat1[0].count == mat2[0].count else { fatalError("Matrix shape error : not same") }
		var result = mat1
		for i in 0..<mat1.count {
			for j in 0..<mat1[0].count {
				result[i][j] = activation(mat1[i][j],mat2[i][j])
			}
		}
		return result
	}
	public class func fillVec(n: Int, value:T) -> [T] {
		return zeroVec(n).map{ _ in value }
	}
	public class func fillMat(row: Int, col: Int, value:T) -> [[T]] {
		return zeroMat(row, col: col).map{ $0.map{_ in value }}
	}
	public class func softmaxVec(vec: [T]) -> [T] {
		guard let max = maxVec(vec) else { fatalError("vec wrong") }
		let preSoftmaxVec = activateVec(vec){ x in
			return T() is Double ? exp((x - max) as! Double) as! T : exp(Double((x - max).toInt())).toInt() as! T
		}
		return activateVec(preSoftmaxVec){ $0 / sumVec(preSoftmaxVec) }
	}
	public class func softmaxMat(mat: [[T]]) -> [[T]] {
		return mat.map{ softmaxVec($0) }
	}
}

