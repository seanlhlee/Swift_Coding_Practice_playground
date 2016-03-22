/*: 
[Previous](@previous)
****
[陳鍾誠]:http://ccc.nqu.edu.tw/db/ccc/home.html ""
[創用CC 姓名標示-相同方式分享3.0 台灣 授權條款]:http://creativecommons.org/licenses/by-sa/3.0/tw/ ""
[ 陳鍾誠 / 教科書 / 人工智慧]:http://ccc.nqu.edu.tw/db/ai/home.html ""

![創用 CC 授權條款](https://i.creativecommons.org/l/by-sa/4.0/88x31.png "創用 CC 授權條款")

本著作以[創用CC 姓名標示-相同方式分享3.0 台灣 授權條款]釋出。

此作品衍生自[ 陳鍾誠 / 教科書 / 人工智慧] : [陳鍾誠] 教授之課程教材。
****

# 實作：以深度優先搜尋解決老鼠走迷宮問題

## 前言

雖然深度優先搜尋 (DFS) 與廣度優先搜尋 (BFS) 等演算法通常是用在「圖形」這種結構上的，不過「圖形」的結構倒是不一定要真實且完整的表達出來，在很多人工智慧的問題上，我們不會看到完整的「圖形結構」，只會看到某個節點有哪些鄰居節點，然後就可以用 BFS 與 DFS 進行搜尋了。

老鼠走迷宮問題，就是一個可以採用圖形搜尋來解決的經典問題，其中每個節點的鄰居，就是上下左右四個方向，只要沒有被牆給擋住，就可以走到鄰居節點去，因此我們可以採用圖形搜尋的方法來解決迷宮問題，以下是我們的程式實作。

程式實作：老鼠走迷宮

檔案：pathFinder.js

	var log = console.log;

	function matrixPrint(m) {
		for(var i=0;i<m.length;i++)
		log(m[i]);
	}

	function strset(s, i, c) {
		return s.substr(0, i) + c + s.substr(i+1);
	}

	function findPath(m, x, y) {
		log("=========================");
		log("x="+x+" y="+y);
		matrixPrint(m);
		if (x>=6||y>=8) return false;
		if (m[x][y] == '*') return false;
		if (m[x][y] == '+') return false;
		if (m[x][y] == ' ') m[x] = strset(m[x], y, '.');
		if (m[x][y] == '.' && (x == 5 || y==7))
		return true;
		if (y<7&&m[x][y+1]==' ') //向右
		if (findPath(m, x,y+1)) return true;
		if(x<5&&m[x+1][y]==' ') //向下
		if (findPath(m, x+1,y)) return true;
		if(y>0&&m[x][y-1]==' ') //向左
		if (findPath(m, x,y-1)) return true;
		if(x>0&&m[x-1][y]==' ') //向上
		if (findPath(m, x-1,y)) return true;
		m[x][y]='+';
		return false;
	}

	var m =["********",
		"** * ***",
		"     ***",
		"* ******",
		"*     **",
		"***** **"];

	findPath(m, 2, 0);
	log("=========================");
	matrixPrint(m);
*/
import Foundation
//var log = console.log;

func matrixPrint(m: [String]) {
	for element in m {
		print(element, terminator: "\n")
	}
}


func findPath(inout m: [String], x: Int, y: Int) -> Bool {
	print("=========================")
	print("x = \(x)   y= \(y)")
	matrixPrint(m)
	var matrix = Array2D(columns: m.count, rows: m[0].characters.count, initialValue: "")
	for i in 0..<matrix.columns {
		for j in 0..<matrix.rows {
			matrix[i, j] = "\(m[i].characters[m[i].characters.startIndex.advancedBy(j)])"
		}
	}					// 將m array轉為matrix (Array2D以方便後續使用) - 因為Swift的字串不為Array
	func matrix2Array() {
		for i in 0..<matrix.columns {
			var string: String = ""
			for j in 0..<matrix.rows {
				string += matrix[i, j]
			}
			m[i] = string
		}
	}							// 將matrix轉回m array
	
	
	guard x < 6 && y < 8 else { return false }			// x, y在限定的6 * 8的matrix內, 超界false
	guard (matrix[x, y] != "*") else { return false }	// 若訪問位置為"*", 代表該位置是牆壁, 傳回false
	guard (matrix[x, y] != "+") else { return false }	// 若訪問位置為"+", 代表該1標記為死路, 傳回false
	if matrix[x, y] == " " {							// 若訪問位置為" ", 代表可以走的路, 走過標記為"."
		matrix[x, y] = "."
		matrix2Array()
	}
	if matrix[x, y] == "." && (x == 5 || y==7) { return true }	// 若訪問位置為"."且達邊界, 代表已走完迷宮, 傳回true
	if (y < 7 && matrix[x, y + 1] == " ")	{			//向右訪問
		if (findPath(&m, x: x, y: y + 1)) { return true }
	}
	if (x < 5 && matrix[x + 1, y] == " ")  {			//向下訪問
		if (findPath(&m, x: x + 1, y: y)) { return true }
	}
	if( y > 0 && matrix[x, y - 1] == " ") {				//向左訪問
		if (findPath(&m, x: x, y: y - 1))  { return true }
	}
	if (x > 0 && matrix[x - 1, y] == " ")  {			//向上訪問
		if (findPath(&m, x: x - 1, y: y)) { return true }
	}
	matrix[x, y] = "+"									//訪問過的路徑未找到出路, 標記為"+"代表死路
	matrix2Array()
	return false
}

var m = [	"********",
			"** * ***",
			"     ***",
			"* ******",
			"*     **",
			"***** **"]

findPath(&m, x: 2, y: 0)
print("=========================")
matrixPrint(m)
/*:
執行結果

	D:\Dropbox\Public\web\ai\code\search>node pathFinder.js
	=========================
	x = 2   y= 0
	********
	** * ***
	***
	* ******
	*     **
	***** **
	=========================
	x = 2   y= 1
	********
	** * ***
	.    ***
	* ******
	*     **
	***** **
	=========================
	x = 2   y= 2
	********
	** * ***
	..   ***
	* ******
	*     **
	***** **
	=========================
	x = 2   y= 3
	********
	** * ***
	...  ***
	* ******
	*     **
	***** **
	=========================
	x = 2   y= 4
	********
	** * ***
	.... ***
	* ******
	*     **
	***** **
	=========================
	x = 1   y= 4
	********
	** * ***
	.....***
	* ******
	*     **
	***** **
	=========================
	x = 1   y= 2
	********
	** * ***
	...+ ***
	* ******
	*     **
	***** **
	=========================
	x = 3   y= 1
	********
	** * ***
	..+  ***
	* ******
	*     **
	***** **
	=========================
	x = 4   y= 1
	********
	** * ***
	..+  ***
	*.******
	*     **
	***** **
	=========================
	x = 4   y= 2
	********
	** * ***
	..+  ***
	*.******
	*.    **
	***** **
	=========================
	x = 4   y= 3
	********
	** * ***
	..+  ***
	*.******
	*..   **
	***** **
	=========================
	x = 4   y= 4
	********
	** * ***
	..+  ***
	*.******
	*...  **
	***** **
	=========================
	x = 4   y= 5
	********
	** * ***
	..+  ***
	*.******
	*.... **
	***** **
	=========================
	x = 5   y= 5
	********
	** * ***
	..+  ***
	*.******
	*.....**
	***** **
	=========================
	********
	** * ***
	..+  ***
	*.******
	*.....**
	*****.**

## 結語

在上面的輸出結果中，* 代表該位置是牆壁，而空格則代表是可以走的路，老鼠走過的地方會放下一個 . 符號，於是您可以看到在上述程式的輸出中，老鼠最後走出了迷宮，完成了任務。

[Next](@next)
*/
