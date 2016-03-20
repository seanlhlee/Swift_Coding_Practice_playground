/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 遞迴

### 請用遞迴計算 n! = n...2*1 ？

範例： factorial(3) = 6
*/
import Foundation
func factroial(n: Int) -> Int {
	guard n != 1 else { return 1 }
	return n * factroial(n - 1)
}
factroial(3)
/*:
### 請寫出計算遞迴函數 f(n) = 2*f(n-1)+f(n-2) 的函數，其中 f(0)=f(1)=1？

範例： f(2) = 2*1+1 = 3, f(3)=2*3+1=7 。
*/
func f(n: Int) -> Int {
	guard n > 1 else { return 1 }
	return 2 * f(n - 1) + f(n - 2)
}
f(2)
f(3)
/*:
### 請用遞迴計算 power(n,k) = n^k = n...n ？

範例：power(2,3) = 8
*/
func power(n: Int, k: Int) -> Int {
	guard k != 0 else { return 1 }
	return n * power(n, k: k - 1)
}
power(2, k: 3)
/*:
### 請用遞迴計算 sum(n) = 1+2+...+n ？

範例：sum(10) = 55
*/
func sum(n: Int) -> Int {
	guard n != 1 else { return 1 }
	return n + sum(n - 1)
}
sum(10)
/*:
****
[Next](@next)
*/

