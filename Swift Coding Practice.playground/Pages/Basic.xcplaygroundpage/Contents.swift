/*:
[Previous](@previous)
****
# SWIFT程式設計練習題
## 基本練習題
### 請寫一個函數 m357(a,b) 列出 a 到 b 之間為 3,5,7 任一數之倍數的所有數值？
範例：m357(10,15) => 10, 12, 14, 15
*/
enum InputError: ErrorType {
	case Negative
	case RangeErr
}
func show357Multiples(from: Int, to: Int) throws -> [Int] {
	guard from > 0 && to > 0 else { throw InputError.Negative }
	guard from < to else { throw InputError.RangeErr }
	let rangeArray = Array(from...to)
	let condition = { (n: Int) -> Bool in
		return (n % 3 == 0) || (n % 5 == 0) || (n % 7 == 0)
	}
	return rangeArray.filter{ condition($0) }
}
do {
	try show357Multiples(10, to: 30)
} catch InputError.Negative {
	print("範圍中不可有負數")
} catch InputError.RangeErr {
	print("範圍有誤, 起始值不能大於終值")
}
/*:
### 請將分數轉換為等第 90+=A, 80+=B, 70+=C, 69-=D

範例： degree(85) => 'B'

[參考]:http://zerojudge.tw/ShowProblem?problemid=a053 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a053
*/
func ranking(score: Int) throws -> Character {
	guard score >= 0 && score <= 100 else { throw InputError.RangeErr }
	switch score {
	case 0..<60:
		return "E"
	case 60..<70:
		return "D"
	case 70..<80:
		return "C"
	case 80..<90:
		return "B"
	case 90...100:
		return "A"
	default:
		throw InputError.RangeErr
	}
}
do {
	try ranking(82)
} catch {
	print("分數範圍有誤")
}
/*:
### 給定兩個數字，請算出它們的最大公因數？

範例： commonFactor(12,15) => 3

[參考]:http://zerojudge.tw/ShowProblem?problemid=a024 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a024
*/
func commonFactor(a: Int, _ b: Int) throws -> Int {
	guard a > 0 && b > 0 else { throw InputError.Negative }
	var x = max(a, b)
	var y = min(a, b)
	while x % y != 0 {
		x = x % y
		swap(&x, &y)
	}
	return y
}
do {
	try commonFactor(12, 15)
} catch {
	print("不可有負數")
}
/*:
*** 將一個10進位的數字換成二進位數字？

範例 binary(6) => "110"

[參考]:http://zerojudge.tw/ShowProblem?problemid=a022 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a022
*/
func binary(n: Int) -> String {
	return String(n, radix: 2)
}
binary(20)
/*:
### 請檢查某數是否為質數？ 範例： isPrime(17) => true

給你兩個數字，請算出這兩個數字之間有幾個質數(包含輸入的兩個數字)？

範例： countPrime(3, 7) => 3

[參考]:http://zerojudge.tw/ShowProblem?problemid=a121 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a121
*/
import Foundation
func countPrime(from: Int, to: Int) throws -> [Int] {  //使用filter速度較慢
	guard from > 1 && to > 1 else { throw InputError.Negative }
	guard from < to else { throw InputError.RangeErr }
	var array = Array(2...to)
	var temp = [2]//[Int]()
	while !array.isEmpty {
		array = array.filter{ $0 % temp.last! != 0 }
		temp += [array.removeFirst()]
	}
	return temp.filter{ $0 >= from }
}
do {
	try countPrime(20, to: 100)
} catch InputError.Negative {
	print("範圍中不可有負數或小於2的數字")
} catch InputError.RangeErr {
	print("範圍有誤, 起始值不能大於終值")
}

func primeTable(inout primes: [Int], from: Int, to n: Int) throws -> [Int] {
	guard from > 1 && n > 1 else { throw InputError.Negative }
	guard from < n else { throw InputError.RangeErr }
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
var primes = [2,3]
do {
	try primeTable(&primes, from: 20, to: 100)
} catch InputError.Negative {
	print("範圍中不可有負數或小於2的數字")
} catch InputError.RangeErr {
	print("範圍有誤, 起始值不能大於終值")
}

/*:
****
[Next](@next)
*/
