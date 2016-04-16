/*:
[Previous](@previous)
****
# SWIFT String Extension

## String Indices 
### [Described in 'The Swift Programming Language (Swift 2.2)' by Apple Inc.]

Each String value has an associated index type, String.Index, which corresponds to the position of each Character in the string.

As mentioned above, different characters can require different amounts of memory to store, so in order to determine which Character is at a particular position, you must iterate over each Unicode scalar from the start or end of that String. For this reason, Swift strings cannot be indexed by integer values.

Use the startIndex property to access the position of the first Character of a String. The endIndex property is the position after the last character in a String. As a result, the endIndex property isn’t a valid argument to a string’s subscript. If a String is empty, startIndex and endIndex are equal.

A String.Index value can access its immediately preceding index by calling the predecessor() method, and its immediately succeeding index by calling the successor() method. Any index in a String can be accessed from any other index by chaining these methods together, or by using the advancedBy(_:) method. Attempting to access an index outside of a string’s range will trigger a runtime error.

You can use subscript syntax to access the Character at a particular String index.

## Use an integer indexing subscription to access Swift strings

	By using the advancedBy(_:) method, we can use an integer number to alternatively index a Swift string. 

## Use an integer range subscription to access Swift strings

*/
public extension String {
	subscript(idx: Int) -> Character {
		get {
			let strIdx = self.startIndex.advancedBy(idx, limit: endIndex)
			guard strIdx != endIndex else { fatalError("String index out of bounds") }
			return self[strIdx]
		}
		set {
			self.removeAtIndex(startIndex.advancedBy(idx, limit: endIndex))
			self.insert(newValue, atIndex: startIndex.advancedBy(idx, limit: endIndex))
		}
	}
	subscript(range: Range<Int>) -> String {
		get {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			return self[strRange]
		}
		set {
			let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
			self.removeRange(strRange)
			self.insertContentsOf(newValue.characters, at: strRange.startIndex)
		}
	}
}

var exampleString = "This is an example of a Swift string."
exampleString[3]  //s
exampleString[3...9]   //s is an
exampleString[3] = "g"
exampleString
exampleString[3...9] = "s is an"
exampleString
exampleString[3...3] = "g"
exampleString
exampleString[3] = "s"
exampleString

/*:
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
		else if char == "1" { countOfOneBits += 1 }
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
		if char == "(" { countL += 1 }
		if char == ")" { countR += 1 }
	}
	return countL == countR
}
 isPaired("(a+3)*5/7)))*8")

/*:
****
[Next](@next)
*/
