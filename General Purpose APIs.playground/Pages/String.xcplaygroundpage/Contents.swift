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
import UIKit

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
	func visualizeView() -> UIView {
		return visualize(self)
	}
	func visualizeView(idx: Int) -> UIView {
		let index = self.startIndex.advancedBy(idx, limit: endIndex)
		return visualize(self, index: index)
	}
	func visualizeView(range: Range<Int>) -> UIView {
		let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
		return visualize(self, range: strRange)
	}
}



var exampleString = "This is an example of a Swift string."
exampleString.visualizeView()
exampleString.visualizeView(3)
visualize("\(exampleString[3])")
exampleString.visualizeView(11...17)
visualize("\(exampleString[11...17])")
exampleString[3] = "g"
exampleString.visualizeView(3)
exampleString[8...17] = "a sample"
exampleString.visualizeView(10...15)
exampleString[8...15] = "an example"
exampleString.visualizeView(11...17)
exampleString[3...3] = "🤖"
exampleString.visualizeView(3)
exampleString[3] = "s"
exampleString.visualizeView()

extension String {
	// 字串倒轉
	public func reverse() -> String {
		let array = self.characters
		var reverse = String.CharacterView()
		for i in 0..<array.count {
			let index = -i - 1
			reverse.append(array[array.endIndex.advancedBy(index)])
		}
		return String(reverse)
	}
}
exampleString.reverse().visualizeView()


/*:
# 最長共同子序列演算法（Longest Common Subsequence）

最長共同子序列（Longest Common Subsequence (LCS)）是指兩個字串中最長的相同次序出現的字元所組成的序列。舉例來說，`"Hello World"`與`"Bonjour le monde"`兩字串的LCS為`"oorld"`。字串由左往右排列字元，可以發現`o`, `o`, `r`, `l`, `d`是以相同的次序出現在兩字串中。其他相同次序的組合還有`"ed"`與`"old"`，都比`"oorld"`來的短。

- note:
通常此問題很容易與最長共同子字串混淆（Longest Common Substring），最長共同子字串指的是兩字串中都有的最長的子字串，而共同子序列是字母出現的順序，這個順序若是連續的亦可組合成字串，然而LCS僅要求出現次序相同，不需要可以組合成字串。其中一種找到兩個字串的最常共同子序列的方法是採用動態規劃（dynamic programming）與回溯策略（backtracking strategy）。

## 以動態規劃（dynamic programming）求LCS的長度

求解兩字串`a`與`b`的最長共同子序列，首先我們先找出這個共同順序的序列之長度。可以利用*動態規劃（dynamic programming）*技巧，意即計算出所有可能性，將其儲存到查詢表中。也可以說是把問題遞迴分割成許多更小的問題，把問題一一對應到表格，決定問題的計算順序。

- note:
下述解說中`n`代表`a`字串的長度而`m`代表`b`字串的長度。

為了找出所有可能的次序，使用一個輔助函式`lcsLength()`來建立一個大小為`(n+1)` × `(m+1)`的矩陣`matrix[x][y]`值為子字串`a[0...x-1]`與子字串`b[0...y-1]`之最長共同子序列(LCS)長度。

假設兩字串`"ABCBX"`與`"ABDCAB"`，則`lcsLength()`傳回的矩陣如下:

	|   | Ø | A | B | D | C | A | B |
	| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
	| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
	| C | 0 | 1 | 2 | 2 | 3 | 3 | 3 |
	| B | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
	| X | 0 | 1 | 2 | 2 | 3 | 3 | 4 |

此例中，`matrix[3][4]`值為`3`，這代表`a[0...2]`與`b[0...3]`或說`"ABC"`與`"ABDC"`的最長共同序列長度為3，因為兩個子字串共同序列有`ABC`。(注意： 矩陣的首行與首列總是0)。以下為`lcsLength()`函式實作的程式碼，我們將其做為`String`類別的拓展(extension)延伸功能：

	func lcsLength(other: String) -> [[Int]] {
		
		var matrix = [[Int]](count: self.characters.count+1,
							 repeatedValue: [Int](count: other.characters.count+1, repeatedValue: 0))
		
		for (i, selfChar) in self.characters.enumerate() {
			for (j, otherChar) in other.characters.enumerate() {
				if otherChar == selfChar {
					// Common char found, add 1 to highest lcs found so far.
					matrix[i+1][j+1] = matrix[i][j] + 1
				} else {
					// Not a match, propagates highest lcs length found so far.
					matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
				}
			}
		}
		
		return matrix
	}

首先，建立一個新的二維矩陣，所有元素先設為0。Then it loops through both strings, 然後`self`與`other`兩字串用迴圈兩兩比對字元是否相同，若相同則在先前已知的長度上+1，若不同則是填入已知的長度。如下圖示：

	|   | Ø | A | B | D | C | A | B |
	| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
	| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
	| C | 0 | 1 | 2 | * |   |   |   |
	| B | 0 |   |   |   |   |   |   |
	| X | 0 |   |   |   |   |   |   |

圖中`*`標記為正在比對的位置，即`C`與`D`兩字元比對，兩字元是不同的，所以標記位置我們填入已知的最長長度`2`：

	|   | Ø | A | B | D | C | A | B |
	| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
	| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
	| C | 0 | 1 | 2 | 2 | * |   |   |
	| B | 0 |   |   |   |   |   |   |
	| X | 0 |   |   |   |   |   |   |

接下的`C`與`C`是相同的，所以填入已知最長2再加1為`3`:


	|   | Ø | A | B | D | C | A | B |
	| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |
	| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
	| C | 0 | 1 | 2 | 2 | 3 | * |   |
	| B | 0 |   |   |   |   |   |   |
	| X | 0 |   |   |   |   |   |   |


持續到最後，`lcsLength()`就可以順利完成整個矩陣。

## 以回溯策略（Backtracking）求LCS的實際序列

至此，可能序列的長度，而最長的長度為4，也是`matrix[n+1][m+1]`的值。接下來可以回溯策略（Backtracking）來求取哪些字元是以相同的次序出現在兩字串中。
由`matrix[n+1][m+1]`開始向上向左回溯來找出長度的變化位置。

	|   |  Ø|  A|  B|  D|  C|  A|  B|
	| Ø |  0|  0|  0|  0|  0|  0|  0|
	| A |  0|↖ 1|  1|  1|  1|  1|  1|
	| B |  0|  1|↖ 2|← 2|  2|  2|  2|
	| C |  0|  1|  2|  2|↖ 3|← 3|  3|
	| B |  0|  1|  2|  2|  3|  3|↖ 4|
	| X |  0|  1|  2|  2|  3|  3|↑ 4|


每個`↖`的移動符號代表LCS中的共同字元。如果在`matrix[i][j]`位置的上方與左方的數字不同，代表該位置是共同字元`a[i - 1]`與`b[j - 1]`，需要注意到逆向追溯使得到的結果會是次序顛倒的，在回傳前需要倒置次序。以下為回溯（backtrack）輔助函式的實作:

	func backtrack(matrix: [[Int]]) -> String {
		var i = self.characters.count
		var j = other.characters.count
		
		var charInSequence = self.endIndex
		
		var lcs = String()
		
		while i >= 1 && j >= 1 {
			// Indicates propagation without change: no new char was added to lcs.
			if matrix[i][j] == matrix[i][j - 1] {
				j -= 1
			}
				// Indicates propagation without change: no new char was added to lcs.
			else if matrix[i][j] == matrix[i - 1][j] {
				i -= 1
				charInSequence = charInSequence.predecessor()
			}
				// Value on the left and above are different than current cell.
				// This means 1 was added to lcs length.
			else {
				i -= 1
				j -= 1
				charInSequence = charInSequence.predecessor()
				lcs.append(self[charInSequence])
			}
		}
		
		return String(lcs.characters.reverse())
	}

此輔助函式由矩陣右下角`matrix[n+1][m+1]`追溯至左上角`matrix[1][1]` (top-right corner)，來找到都有出現在兩字串中的字元並將其加到暫存字串`lcs`中。`charInSequence`變數為`self`字串中字元的索引值，由尾端開始。每當`i`在迴圈遞減時，同時對`charInSequence`變數遞減。當找到相同字元的位置時，我們將字元`self[charInSequence]`增加至`lcs`字串中。回傳結果前以`reverse()`倒置字串順序。

## 將輔助函式整合

要得到兩個字串中最長的相同次序出現的字元所組成的序列，先呼叫`lcsLength()`再呼叫`backtrack()`：

*/
extension String {
	public func longestCommonSubsequence(other: String) -> String {
		
		func lcsLength(other: String) -> [[Int]] {
			
			var matrix = [[Int]](count: self.characters.count+1,
			                     repeatedValue: [Int](count: other.characters.count+1, repeatedValue: 0))
			
			for (i, selfChar) in self.characters.enumerate() {
				for (j, otherChar) in other.characters.enumerate() {
					if otherChar == selfChar {
						// Common char found, add 1 to highest lcs found so far.
						matrix[i+1][j+1] = matrix[i][j] + 1
					} else {
						// Not a match, propagates highest lcs length found so far.
						matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
					}
				}
			}
			
			return matrix
		}
		
		func backtrack(matrix: [[Int]]) -> String {
			var i = self.characters.count
			var j = other.characters.count
			
			var charInSequence = self.endIndex
			
			var lcs = String()
			
			while i >= 1 && j >= 1 {
				// Indicates propagation without change: no new char was added to lcs.
				if matrix[i][j] == matrix[i][j - 1] {
					j -= 1
				}
					// Indicates propagation without change: no new char was added to lcs.
				else if matrix[i][j] == matrix[i - 1][j] {
					i -= 1
					charInSequence = charInSequence.predecessor()
				}
					// Value on the left and above are different than current cell.
					// This means 1 was added to lcs length.
				else {
					i -= 1
					j -= 1
					charInSequence = charInSequence.predecessor()
					lcs.append(self[charInSequence])
				}
			}
			
			return String(lcs.characters.reverse())
		}
		
		return backtrack(lcsLength(other))
	}
	
	public static func longestCommonSubsequence(aString aString: String, bString: String) -> String {
		return aString.longestCommonSubsequence(bString)
	}
}
/*:

為了整齊起見，我們將兩個`longestCommonSubsequence()`函式之輔助函式寫為其當中的巢狀函式。以下是可在Playground中測試的程式碼：
*/

let a = "ABCBX"
let b = "ABDCAB"
a.longestCommonSubsequence(b)   // "ABCB"

let c = "KLMK"
a.longestCommonSubsequence(c)   // "" (no common subsequence)

"Hello World".longestCommonSubsequence("Bonjour le monde")   // "oorld"

let hello = "Hello World"
let bonjour = "Bonjour le monde"

String.longestCommonSubsequence(aString: a, bString: b)
String.longestCommonSubsequence(aString: hello, bString: bonjour)


/*:
****
[Next](@next)
*/
