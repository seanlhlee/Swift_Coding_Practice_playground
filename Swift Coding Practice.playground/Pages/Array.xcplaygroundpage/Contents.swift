/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 陣列

### 請在一個已經排序的陣列中之正確位置插入一個數值。

範例： insert([1,2,5,6,7], 3) => [1,2,3,5,6,7]
*/
import Foundation

func insert<T: Comparable>(inout array: [T], n: T) -> [T] {
	array.append(n)
	return array.sort(<)
}
var array = [1,2,5,6,7]
array = insert(&array, n: 3)
/*:
### 請用二分搜尋法搜尋一個已經排好序的陣列。

範例： find([ 1, 4, 5, 8, 9], 5) => 2 , 找不到時傳回 -1。
*/
func binarySearch<T: Comparable>(a: [T], key: T) -> Int? {
	var range = 0..<a.count
	while range.startIndex < range.endIndex {
		let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
		if a[midIndex] == key {
			return midIndex
		} else if a[midIndex] < key {
			range.startIndex = midIndex + 1
		} else {
			range.endIndex = midIndex
		}
	}
	return nil
}
func find<T: Comparable>(a: [T], key: T) -> Int? {
		return binarySearch(a, key: key)
}


find(array, key: 6)

/*:
### 請將 a 到 b 之間無法被 3, 5, 7 整除的數字放到陣列中？

範例： filter357(6,25) = [8, 11, 13, 16, 17, 19, 22, 23]

[參考]:http://zerojudge.tw/ShowProblem?problemid=a147 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a147
*/
enum InputError: ErrorType {
	case Negative
	case RangeErr
}
func showNot357Multiples(from: Int, to: Int) throws -> [Int] {
	guard from > 0 && to > 0 else { throw InputError.Negative }
	guard from < to else { throw InputError.RangeErr }
	let rangeArray = Array(from...to)
	let condition = { (n: Int) -> Bool in
		return (n % 3 != 0) && (n % 5 != 0) && (n % 7 != 0)
	}
	return rangeArray.filter{ condition($0) }
}
do {
	try showNot357Multiples(6, to: 25)
} catch InputError.Negative {
	print("範圍中不可有負數")
} catch InputError.RangeErr {
	print("範圍有誤, 起始值不能大於終值")
}

try showNot357Multiples(5, to: 10)

/*:
### 請算出某陣列的平均值？

範例： mean([1,2,3,4,5]) => 3
*/
//protocol Computable { func toDouble() -> Double }
//
//extension UInt: Computable { func toDouble() -> Double { return Double(self) } }
//extension Int8: Computable { func toDouble() -> Double { return Double(self) } }
//extension UInt8: Computable { func toDouble() -> Double { return Double(self) } }
//extension Int16: Computable { func toDouble() -> Double { return Double(self) } }
//extension UInt16: Computable { func toDouble() -> Double { return Double(self) } }
//extension Int32: Computable { func toDouble() -> Double { return Double(self) } }
//extension UInt32: Computable { func toDouble() -> Double { return Double(self) } }
//extension Int64: Computable { func toDouble() -> Double { return Double(self) } }
//extension UInt64: Computable { func toDouble() -> Double { return Double(self) } }
//extension Int: Computable { func toDouble() -> Double { return Double(self) } }
//extension Float: Computable { func toDouble() -> Double { return Double(self) } }
//extension Double: Computable { func toDouble() -> Double { return self } }

func mean<T: Computable>(array: [T]) -> Double {
	guard !array.isEmpty else { return 0 }
	let doubleArray = array.flatMap{ $0.toDouble() }
	return doubleArray.reduce(0.0) { $0 + $1 } / Double(doubleArray.count)
}

array += [9]
mean(array)
/*:
### 請算出某陣列的標準差？ (標準差為 (xi-x)^2 的總和)

![](https://upload.wikimedia.org/math/0/a/c/0ac347485c796546777e0b1d01e2aa63.png "")

範例： sd([1,2,3,4,5]) = sqrt((2^2+1^2+0^2+1^2+2^2)/5) = sqrt(2)=1.414。
*/
func sigma<T: Computable>(array: [T]) -> Double {
	guard !array.isEmpty else { return 0 }
	let mu = mean(array)
	let squareSum = array.flatMap{ $0.toDouble() }.map{ $0 - mu }.map{ $0 * $0 }.reduce(0.0){ $0 + $1 }
	return sqrt( squareSum / Double(array.count) )
}
array = [5,6,8,9]
sigma(array)
array = [1,2,3,4,5]
sigma(array)
/*:
### 請寫一個數找出一個排序好陣列中差異最小的兩個數之距離？

範例： minGap([1,3,6,7,10]) = 1
*/
func minGap<T: Computable>(array: [T]) -> Double {
	guard !array.isEmpty else { return 0 }
	let dbArray = array.flatMap{ $0.toDouble() }
	var gaps = [Double]()
	for i in 0..<dbArray.count - 1 {
		gaps.append( dbArray[i + 1] - dbArray[i] )
	}
	
	return gaps.sort()[0]
}
var arrayx = [1.3, 2.1, 3, 5.5, 7, 16, 23.5]
minGap(arrayx)
/*:
### 請寫一個函數 random(n, a, b) 可以產生 n 個介於 a 到 b 之間的浮點亂數？

範例： random(3, 10, 20)= [13.76, 19,23, 14,11]
*/
func random(n: Int, a: Int, b: Int) -> [Double] {
	let range = b > a ? (b - a).toDouble() : (a - b).toDouble()
	var array = [Double]()
	for _ in 0..<n {
		let c = arc4random().toDouble() / UInt32.max.toDouble() * range + a.toDouble()
		array.append(c)
	}
	return array
}
random(5, a: 10, b: 23)


/*:
### 寫一個程式做因數分解。

範例：factor(45) => [3, 3, 5]

[參考]:http://zerojudge.tw/ShowProblem?problemid=a010 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a010
*/
func primeTable(inout primes: [Int], from: Int, to n: Int)-> [Int] {
//	guard from > 1 && n > 1 else { throw }
//	guard from < n else { throw InputError.RangeErr }
	func isPrime(number: Int) -> Bool {
		for prime in primes {
			guard !(prime * prime > number) else { break }
			if number % prime == 0 {
				return false
			}
		}
		return true
	}
	for i in primes.last! + 1 ... n {
		if isPrime(i) {
			primes.append(i)
		}
	}
	return primes.filter{ $0 >= from }
}
func integerFactorixation(n: Int, primer: [Int]) -> [Int] {
	var array = primer
	var preprimes = [2,3]
	let primes = primeTable(&preprimes, from: 2, to: n)
	for prime in primes {
		guard !(n < prime) else {break}
		guard n != prime else {
			array.append(prime)
			return array
		}
		if n % prime == 0 {
			array.append(prime)
			return integerFactorixation(n / prime, primer: array)
		}
	}
	return array
}
integerFactorixation(120, primer: [])
integerFactorixation(248, primer: [])
integerFactorixation(45, primer: [])



/*:
****
[Next](@next)
*/
