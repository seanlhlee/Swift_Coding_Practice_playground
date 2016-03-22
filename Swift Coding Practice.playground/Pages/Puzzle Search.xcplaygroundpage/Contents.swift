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

# 實作：以廣度優先搜尋解決拼圖問題

## 前言

以下的「拼圖問題」是將一個已經移動打亂過的拼盤，想辦法移動回原本樣子的問題。

圖、本文程式中的拼圖問題

在以下程式中，我們用一個 3*3 的陣列來代表拼盤，並且用數字 0 來代表其中的空格，因此將方塊 2 移動到空格，其實是用將 0 與 2 兩個數字位置交換所達成的。

透過這樣的資料結構，我們就可以用「廣度優先搜尋」(BFS) 來解決拼圖問題了，以下是我們用 JavaScript 實作，並用 node.js 進行測試的結果。

## 程式實作：拼圖問題

檔案：puzzleSearch.js

	var util = require("util");
	var log = console.log;
	var up = 1, right=2, down=3, left=4;

	function enqueue(a, o) { a.push(o); }
	function dequeue(a) { return a.shift(); }
	function equal(a, b) { return JSON.stringify(a)===JSON.stringify(b); }
	function board2str(b) { return b.join("\n"); }

	function findXY(board, value) {
		for (var x=0; x<board.length; x++)
			for (var y=0; y<board[x].length; y++)
				if (board[x][y] === value)
					return {x:x,y:y};
		return null;
	}

	function boardClone(b) {
		var nb = [];
		for (var x in b)
			nb[x] = b[x].slice(0);
		return nb;
	}

	function swap(b,x1,y1,x2,y2) {
		x2 = Math.round(x2), y2=Math.round(y2);
		if (x2<0 || x2 > 2 || y2<0 || y2>2)
			return false;
		var t = b[x1][y1];
		b[x1][y1]=b[x2][y2];
		b[x2][y2]=t;
		return true;
	}

	function move(board, dir) {
		var xy = findXY(board, 0);
		var x = xy.x, y=xy.y;
		var nboard = boardClone(board);
		var s = false;
		switch (dir) {
			case up:    s=swap(nboard,x,y,x-1,y); break;
			case right: s=swap(nboard,x,y,x,y+1); break;
			case down:  s=swap(nboard,x,y,x+1,y); break;
			case left:  s=swap(nboard,x,y,x,y-1); break;
		}
		if (s)
			return nboard;
		else
			return null;
	}

	function moveAdd(board, dir, neighbors) {
		var nboard = move(board, dir);
		if (nboard !== null) {
			neighbors.push(nboard);
		}
	}

	function getNeighbors(board) {
		var neighbors = [];
		moveAdd(board, up,    neighbors);
		moveAdd(board, down,  neighbors);
		moveAdd(board, right, neighbors);
		moveAdd(board, left,  neighbors);
		return neighbors;
	}

	var goal = [[1,2,3],
				[8,0,4],
				[7,6,5]];

	var start= [[1,3,4],
				[8,2,5],
				[7,0,6]];

	var queue=[start];            // BFS 用的 queue, 起始點為 1。
	var visited={};
	var parent={};
	var level={};

	function bfs(q, goal) { // 廣度優先搜尋
		while (q.length > 0) {
			var node = dequeue(q);     // 否則、取出 queue 的第一個節點。
			var nodestr = board2str(node);
			//  log("q.length=%d level=%d\n===node===\n%s==parent==\n%s", q.length, level[nodestr], nodestr, parent[nodestr]); // 印出節點
			if (equal(node, goal)) return true;
			if (visited[nodestr]===undefined)        // 如果該節點尚未拜訪過。
				visited[nodestr] = true; //   標示為已拜訪
			else                       // 否則 (已訪問過)
				continue;                //   不繼續搜尋，直接返回。
			var neighbors = getNeighbors(node); // 取出鄰居。
			for (var i in neighbors) { // 對於每個鄰居
				var n = neighbors[i];
				var nstr = board2str(n);
				if (!visited[nstr]) {    // 假如該鄰居還沒被拜訪過
					parent[nstr] = nodestr;
					level[nstr] = level[nodestr] + 1;
					enqueue(q, n);         //   就放入 queue 中
				}
			}
		}
		return false;
	}

	function backtrace(goal) {
		log("======= backtrace =========");
		var nodestr = board2str(goal);
		while (nodestr !== undefined) {
		log("%s\n", nodestr);
		nodestr = parent[nodestr];
		}
	}

	level[board2str(start)]=0;
	var found = bfs(queue, goal); // 呼叫廣度優先搜尋。
	log("bfs:found=%s", found);
	if (found)
		backtrace(goal);
*/
import Foundation
/*
{
/// 定義拼圖盤面相等的判斷函式，用於bfs中判斷結點盤面是否符合搜尋目標。
func == (lhs: [[Int]], rhs: [[Int]]) -> Bool {
	guard !lhs.isEmpty && !rhs.isEmpty else { return false }
	guard lhs.count == rhs.count else { return false }
	guard lhs.description == rhs.description else { return false }
	return true
}
public func ==<T> (lhs: [T], rhs: [T]) -> Bool {
	guard !lhs.isEmpty && !rhs.isEmpty else { return false }
	guard lhs.count == rhs.count else { return false }
	guard lhs.description == rhs.description else { return false }
	return true
}
/// 將Array採納(confirm)Equatable協議, 使其得以作為Node類別之屬性value的值
extension Array: Equatable { }
public func ==<T> (lhs: Node<T>, rhs: Node<T>) -> Bool {
	guard lhs.value == rhs.value else { return false }
	guard lhs.name == rhs.name else { return false }
	return true
}
/// 將Node採納(confirm)Equatable協議, 用以新增相鄰節點時不重複增加已鏈結之節點
extension Node: Equatable {}
/** 將數字陣列形式的拼圖轉換為易讀的拼圖形式顯示字串，以方便以print函式觀察結果
	例如將陣列 [[1,2,3], [8,0,4], [7,6,5]]轉換後顯示為
										[1,2,3]
	[[1,2,3], [8,0,4], [7,6,5]]   =>	[8,0,4]
										[7,6,5]
*/
}
*/
func board2str(b: [[Int]]) -> String {
	return b.flatMap{ String($0) }.joinWithSeparator("\n")
}
/// 根據拼圖盤面的狀況取得存在之相鄰節點 (往四個方向移動的可能性，加入節點之鄰居節點關係) moveable參數為可移動之圖塊
func addNeighbors(node: Node<[[Int]]>, moveable: Int = 0) {
	/// 定義方向的列舉
	enum Direction{
		case up, right, down, left
	}
	/// 若可移動，則將移動後的盤面加入為目前該節點的鄰居節點
	func moveAdd(node: Node<[[Int]]>, dir: Direction, moveable: Int) {
		/// 將拼圖中的某塊拼圖移動至新的位置後，傳回新的拼圖圖案
		func move(node: Node<[[Int]]>, dir: Direction) -> Node<[[Int]]>? {
			/// 置換拼圖中(數字陣列形式)兩塊拼圖(數字)的位置
			func swap_point(inout b: [[Int]],p1: (Int,Int), p2: (Int,Int)) -> Bool {
				guard (p2.0 >= 0 && p2.0 <= 2 && p2.1 >= 0 && p2.1 <= 2) else { return false }
				swap(&b[p1.0][p1.1], &b[p2.0][p2.1])
				return true
			}
			/// 尋找目標值(數字)在拼圖中(數字陣列形式)的位置
			let board = node.value
			func findXY(board: [[Int]], value: Int) -> (x: Int, y: Int)? {
				for i in 0..<board.count {
					for j in 0..<board[0].count {
						if board[i][j] == value {
							return (x: i, y: j)
						}
					}
				}
				return nil
			}
			let x = findXY(board, value: moveable)!.x
			let y = findXY(board, value: moveable)!.y
			var nboard = board
			var s = false
			switch dir {
			case .up:
				s = swap_point(&nboard, p1: (x,y), p2: (x-1,y))
			case .right:
				s = swap_point(&nboard, p1: (x,y), p2: (x,y+1))
			case .down:
				s = swap_point(&nboard, p1: (x,y), p2: (x+1,y))
			case .left:
				s = swap_point(&nboard, p1: (x,y), p2: (x,y-1))
			}
			if s {
				let newNode = Node(name: board2str(nboard), value: nboard)
				for neighbot in node.getConn() {
					if newNode == neighbot {
						return nil
					}
				}
				return newNode
			} else { return nil }
		}
		if let newNode = move(node, dir: dir) {
			for neighbot in node.getConn() {
				if newNode == neighbot {
					return
				}
			}
			node.addNeighbor(newNode)
		}
	}
	moveAdd(node, dir: .up, moveable: moveable)
	moveAdd(node, dir: .down, moveable: moveable)
	moveAdd(node, dir: .right, moveable: moveable)
	moveAdd(node, dir: .left, moveable: moveable)
}

/// 定義追蹤歷程的字典型態
var parent: [String: String] = [:]
/// 定義搜尋深度的字典型態
var level: [String: Int] = [:]
/// 追蹤搜尋的字串(用node的name來進行追蹤)
var nodestr: String? = nil
/// 廣度優先搜尋, moveable參數為可移動的圖塊編號, 預設值為0
func bfs(g: [[Int]], inout q: Queue<Node<[[Int]]>>, moveable: Int = 0) -> Bool {
	guard !q.isEmpty else { return false }					// 如果 queue 已空，則返回。
	if let node = q.dequeue() {								// 否則、取出 queue 的第一個節點。
		nodestr = node.name
		guard !node.visited else { return false }			// 如果該節點拜訪過，繼續搜尋；否則，直接返回。
		node.visited = true									// 標示為已拜訪
		if node.value == g {
			print("Found solution @\n\(nodestr!)")			// 印出節點
			return true
		}
		addNeighbors(node, moveable: moveable)				// 計算並新增個節點鄰居。
		let neighbors = node.getConn()						// 取出鄰居。
		neighbors.count
		if !neighbors.isEmpty {
			for rote in neighbors {							// 對於每個鄰居
				let nstr = board2str(rote.value)
				if !rote.visited {							// 假如該鄰居還沒被拜訪過
					parent[nstr] = nodestr					// 追蹤搜尋節點, 利用紀錄鄰居節點的來源節點為自己之特性追蹤
					level[nstr] = level[nodestr!]! + 1		// 追蹤搜尋節點的深度
					q.enqueue(rote)							// 就放入 queue 中
				}
			}
			bfs(g, q: &q)
		}
	}
	return true
}

func backtrace(goal: [[Int]]) {
	print("======= backtrace =========")
	var nodestr: String? = board2str(goal)
	while (nodestr != nil) {
		print("Tracking Level:\n--- Level:\(level[nodestr!]!) ---")
		print(nodestr!, terminator: "\n\n")
		nodestr = parent[nodestr!]
	}
}

/// 設定起始圖樣與目標圖樣
var goal = [[1,2,3],
            [8,0,4],
            [7,6,5]]
var start = [[1,3,4],
             [8,2,5],
             [7,0,6]]
let startNode = Node(name: board2str(start), value: start)
let goalNode = Node(name: board2str(goal), value: start)
var queue = Queue<Node<[[Int]]>>()
/// BFS 用的 queue, 起始點為startNode。
queue.enqueue(startNode)

level[board2str(start)] = 0
var found = bfs(goal, q: &queue, moveable: 0) // 呼叫廣度優先搜尋。
if (found) { backtrace(goal) }

/*:
## 執行結果

	D:\Dropbox\Public\web\ai\code\search>node puzzleSearch.js
	bfs:found=true
	======= backtrace =========
	1,2,3
	8,0,4
	7,6,5

	1,0,3
	8,2,4
	7,6,5

	1,3,0
	8,2,4
	7,6,5

	1,3,4
	8,2,0
	7,6,5

	1,3,4
	8,2,5
	7,6,0

	1,3,4
	8,2,5
	7,0,6

## 結語

在上述執行結果中，我們是將盤面拼完後，才逆向追蹤印出移動過程，因此整個移動方法應該從最下面的盤面看起。換句話說，真正的順序如下：

	1,3,4    1,3,4    1,3,4     1,3,0    1,0,3    1,2,3
	8,2,5 => 8,2,5 => 8,2,0 =>  8,2,4 => 8,2,4 => 8,0,4
	7,0,6    7,6,0    7,6,5     7,6,5    7,6,5    7,6,5

從上面過程中，您可以看出我們的程式將打亂的盤面給拼回來了。

****
[Next](@next)
*/
