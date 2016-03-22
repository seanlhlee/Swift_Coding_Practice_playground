/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 字串

### 請判斷一個字串是否是一個迴文？

範例： palindrome("abcba") => true

[參考]:http://zerojudge.tw/ShowProblem?problemid=a022 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a022
*/
func palindrome(str: String) -> Bool {
	let s = str.characters.startIndex
	let e = str.characters.endIndex.advancedBy(-1)
	let halflength = str.characters.count / 2
	let halfD = str.characters.count % 2 == 0 ? halflength - 1 : halflength //決定iteration distance
	for i in 0...halfD {
		 if str.characters[s.advancedBy(i)] != str.characters[e.advancedBy(-i)] { return false }
	}
	return true
}
var str = "abcbA"
palindrome(str)
str = "abcba"
palindrome(str)

/*:
### 請將輸入的字串翻轉？

範例 reverse("abcde") => "edcba"

[參考]:http://zerojudge.tw/ShowProblem?problemid=a038 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a038
*/
func reverse(str: String) -> String {
	let array = str.characters
	var reverse = String.CharacterView()
	for i in 0..<array.count {
		let index = -i - 1
		reverse.append(array[array.endIndex.advancedBy(index)])
	}
	return String(reverse)
}
reverse(str)
str = "I am a MacBook air."
reverse(str)
/*:
### 請輸出某二進位字串的偶校驗位元 (parity bit)

A parity bit, or check bit is a bit added to the end of a string of binary code that indicates whether the number of bits in the string with the value one is even or odd. Parity bits are used as the simplest form of error detecting code.

There are two variants of parity bits: even parity bit and odd parity bit.

範例： evenParity("1010001") => 1

[參考]:http://zerojudge.tw/ShowProblem?problemid=a054 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a054
*/
func evenParity(bitCode: String) -> Int {
	let chars = bitCode.characters
	var countOfOneBits = 0
	for char in chars {
		if char != "0" && char != "1" { return -1 }
		else if char == "1" { ++countOfOneBits }
	}
	return countOfOneBits % 2
}
func evenParity(num: Int) -> Int {
	let bitCode = String(num, radix: 2)
	return evenParity(bitCode)
}

evenParity("1010001")
evenParity(15)
/*:
### 請輸出某二進位字串的1補數

範例： complement1("10101010") => "01010101"
*/
func complement(bitCode: String) -> String {
	let chars = bitCode.characters
	var revChars = String.CharacterView()
	let len = chars.count
	for i in 0..<len {
		let index = chars.startIndex.advancedBy(i)
		if chars[index] != "0" && chars[index] != "1" { return "error" }
		if chars[index] == "0"{
			revChars.append("1")
		} else {
			revChars.append("0")
		}
	}
	return String(revChars)
}
func complement(num: Int) -> String {
	let bitCode = String(num, radix: 2)
	return complement(bitCode)
}

complement("1011")
complement(15)
/*:
### 請寫一個程式檢查數學是中的括號是否合法？

範例： isPaired("(a+3)*5/7)))*8") => false

[參考]:http://zerojudge.tw/ShowProblem?problemid=a229 ""
[參考]：http://zerojudge.tw/ShowProblem?problemid=a229
*/
func isPaired(str: String) -> Bool {
	var countL = 0, countR = 0
	for char in str.characters {
		if char == "(" { ++countL }
		if char == ")" { ++countR }
	}
	return countL == countR
}
 isPaired("(a+3)*5/7)))*8")

/*:
****
[Next](@next)
*/
