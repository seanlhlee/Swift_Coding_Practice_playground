/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 回呼

### 請寫一個函數可以傳回陣列的映射值？

範例：map(sqrt, [1,4,9])= [1,2,3]
*/
import Foundation
func sqrt(x: Int) -> Int {
	return Int(sqrt(x.toDouble()))
}

func map(array: [Int], op: (Int) -> Int) -> [Int] {
	var mapd = [Int]()
	for element in array {
		mapd.append(op(element))
	}
	return mapd
}
var array = [1, 4, 9]
map(array){ sqrt($0) }

/*:
### 請寫一個函數可以根據過濾函數f只留下符合的內容？

範例：filter(odd, [1,3,5,4,8,9])= [1,3,5,9] ，其中 odd 為判斷是否為奇數的函數。
*/
array = [1,3,5,4,8,9].filter{ $0 % 2 == 1 }
array = [1,3,5,4,8,9]
func odd(n: Int) -> Bool {
	return n % 2 == 1
}
func filter(array: [Int], condition: (Int) -> Bool) -> [Int] {
	var a = [Int]()
	for element in array {
		if condition(element) {
			a.append(element)
		}
	}
	return a
}
filter(array, condition: odd)

/*:
### 請寫一個函數 df(f,x) 可以做數值微分？

範例： df(sin, Pi/4) = 0.707
*/
func df(f y: (Double) -> Double, at x: Double) -> Double {
	let dx: Double = 0.00000001
	let dy: Double = y(x + dx) - y(x)
	return dy / dx
}
let pi = M_PI
df(f: sin, at: pi/4)
/*:
### 請寫一個函數 integral(f, a, b) 可以做數值積分？

範例： integral(sin, 0, Pi) = 2
*/
func area(f y: (Double) -> Double, from x0: Double, to x1: Double) -> Double {
	var area: Double = 0
	let dx = 0.0001
	var x = x0
	repeat {
		area += y(x) * 0.0001
		x += dx
	} while x < x1
	return area
}
area(f: sin, from: 0,to: pi)
/*:
****
[Next](@next)
*/
