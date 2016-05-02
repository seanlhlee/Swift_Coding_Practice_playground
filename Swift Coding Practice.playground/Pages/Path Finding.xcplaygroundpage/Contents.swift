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
	var matrix = Array2D(rows: m.count, columns: m[0].characters.count, initialValue: "")
	for i in 0..<matrix.rows{
		for j in 0..<matrix.columns {
			matrix[i, j] = "\(m[i].characters[m[i].characters.startIndex.advancedBy(j)])"
		}
	}					// 將m array轉為matrix (Array2D以方便後續使用) - 因為Swift的字串不為Array
	func matrix2Array() {
		for i in 0..<matrix.rows {
			var string: String = ""
			for j in 0..<matrix.columns {
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

## An example.
* experiment: Hunter have a wolf, a sheep and a basket of vegetables. He wants to go across the bridge from the westside.
The bridge is not strong enough to make him walk across with more than two belongings. In other words, he can carry one item or just himself to walk across the bridge.
Wolf will eat sheep and sheep will eat vegetables when hunter is absent.
Please find a way to help hunter go to the eastside of the bridge without losses.
*/

enum Role: Int, CustomStringConvertible {
	case hunter = 0, wolf, veg, sheep
	var description: String {
		switch self {
		case .hunter:
			return "Hunter"
		case .sheep:
			return "Sheep"
		case .wolf:
			return "Wolf"
		case .veg:
			return "Vegetables"
		}
	}
}

func == (lhs: [Role], rhs: [Role]) -> Bool {
	guard lhs.count == rhs.count else { return false }
	for i in lhs.indices {
		guard lhs[i] == rhs[i] else { return false }
	}
	return true
}

enum Dir {
	case west, east
}

var record = [[Role]]()

struct Solution: CustomStringConvertible, Equatable {
	var westState: [Role]
	var eastState: [Role]
	init() {
		self.westState = [.hunter, .sheep, .veg, .wolf]
		self.eastState = []
		record.append(self.westState.sort{$0.rawValue < $1.rawValue})
	}
	init(westState: [Role], eastState: [Role]) {
		self.westState = westState
		self.eastState = eastState
	}
	static func willPass(sol: Solution) -> Bool {
		func safe(state: [Role]) -> Bool {
			guard !state.isEmpty else { return true }
			guard !state.contains(.hunter) else { return true }
			if state.contains(.sheep) && state.contains(.wolf) {
				return false
			}
			if state.contains(.sheep) && state.contains(.veg) {
				return false
			}
			return true
		}
		return safe(sol.westState) && safe(sol.eastState)
	}
	static func getOppositeState(formThisSideState: [Role]) -> [Role] {
		let initState: [Role] = [.hunter, .sheep, .veg, .wolf]
		return initState.flatMap{ formThisSideState.contains($0) ? nil : $0}
	}
	mutating func go(dir: Dir, who: [Role]) {
		switch dir {
		case .east:
			eastState += who
			westState = Solution.getOppositeState(eastState)
		case .west:
			westState += who
			eastState = Solution.getOppositeState(westState)
		}
	}
	mutating func goNeibor() -> Bool {
		guard eastState != [.hunter, .sheep, .veg, .wolf] else { return true }
		let dir:Dir = westState.contains(.hunter) ? .east : .west
		let candidate:[Role] =  westState.contains(.hunter) ? westState.filter{ $0 != .hunter } : eastState.filter{ $0 != .hunter }
		var who = [Role.hunter]
		var possible = [(Dir, [Role])]()
		for i in 0...candidate.count {
			var temp = self
			who = i == candidate.count ? [Role.hunter] : [Role.hunter, candidate[i]]
			temp.go(dir, who: who)
			if Solution.willPass(temp) && !(record.contains{$0 == temp.westState.sort{$0.rawValue < $1.rawValue}  }) {
				possible.append((dir,who))
			}
		}
		if possible.isEmpty { return false }
		else if possible.count == 1 {
			self.go(possible[0].0, who: possible[0].1)
			record.append(westState.sort{$0.rawValue<$1.rawValue})
		} else {
			let me = self
			for i in 0..<possible.count {
				self.go(possible[i].0, who: possible[i].1)
				record.append(westState.sort{$0.rawValue<$1.rawValue})
				self =  i < possible.count - 1 ? me : self
			}
		}
		print(self)
		goNeibor()
		return true
	}
	var description: String {
		return "east:\(eastState)"
	}
}

func == (lhs: Solution, rhs: Solution) -> Bool {
	return lhs.eastState == rhs.eastState && lhs.westState == rhs.westState
}

var sol = Solution()
sol.goNeibor()

/*:
## Use dfs method to solve hunter cross bridge problem.
*/

var objs:[Role]	= [.hunter, .wolf, .sheep, .veg]
var state	= [ 0, 0, 0, 0 ]
func neighbors(s: [Int]) -> [[Int]] {
	let side = s[0]
	var next:[[Int]] = []
	checkAdd(&next, s: move(s,obj: Role(rawValue: 0)!))
	for i in 1..<s.count {
		if s[i] == side {
			checkAdd(&next, s: move(s,obj: Role(rawValue: i)!))
		}
	}
	return next
}


func checkAdd(inout next: [[Int]], s: [Int]) {
	if (!isDead(s)) {
		next.append(s)
	}
}

func isDead(s: [Int]) -> Bool {
	if (s[1] == s[2] && s[1] != s[0]) { return true }
	if (s[2] == s[3] && s[2] != s[0]) { return true }
	return false
}

// 人帶著 obj 移到另一邊
func move(s: [Int], obj: Role) -> [Int] {
	var newS = s // 複製一份陣列
	let side = s[0]
	let anotherSide = (side==0) ? 1 : 0
	newS[0] = anotherSide
	newS[obj.rawValue] = anotherSide
	return newS
}

var visitedMap: [String: Bool] = [:]

func visited(s: [Int]) -> Bool {
	let str = state2str(s)
	if let x = visitedMap[str] {
		return x
	}
	return false
}

func isSuccess(s: [Int]) -> Bool {
	for i in 0..<s.count {
		if (s[i] == 0) { return false }
	}
	return true
}

func state2str(s: [Int]) -> String {
	var str = ""
	for i in 0..<s.count {
		str += "\(objs[i]): \(s[i]) "
	}
	return str
}

var path:[[Int]] = []

func printPath(path: [[Int]]) {
	for i in 0..<path.count {
		print(state2str(path[i]))
	}
}

func dfs(s: [Int]) {
	if (visited(s)) { return }
	path.append(s)
	if (isSuccess(s)) {
		print("success!")
		printPath(path)
		return
	}
	visitedMap[state2str(s)] = true
	var neighborsList = neighbors(s)
	for i in neighborsList.indices {
		dfs(neighborsList[i])
	}
	path.removeLast()
}

dfs(state)


/*:
[Next](@next)
*/
