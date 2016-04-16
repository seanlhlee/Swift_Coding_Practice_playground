import Foundation

//產生一個高斯分布的亂數, 平均值為0, 標準差為1
func randn() -> Double {
	// generate random guassian distribution number. (mean : 0, standard deviation : 1)
	var v1, v2, s: Double
	
	repeat {
		v1 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
		v2 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
		s = v1 * v1 + v2 * v2
	} while (s >= 1.0 || s == 0.0)
	
	s = sqrt( (-2.0 * log(s)) / s )
	return v1 * s
}

// 計算陣列中所有元素之標準差
func sigma<T: Computable>(array: [T]) -> Double {
	guard !array.isEmpty else { return 0 }
	func mean<T: Computable>(array: [T]) -> Double {
		guard !array.isEmpty else { return 0 }
		let doubleArray = array.flatMap{ $0.toDouble() }
		return doubleArray.reduce(0.0) { $0 + $1 } / Double(doubleArray.count)
	}
	let mu = mean(array)
	let squareSum = array.flatMap{ $0.toDouble() }.map{ $0 - mu }.map{ $0 * $0 }.reduce(0.0){ $0 + $1 }
	return sqrt( squareSum / Double(array.count) )
}

