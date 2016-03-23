import Foundation

/// 定義拼圖盤面相等的判斷函式，用於bfs中判斷結點盤面是否符合搜尋目標。
public func == (lhs: [[Int]], rhs: [[Int]]) -> Bool {
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
/// 將Array採納(confirm)Equatable協議, 使其得以作為NodeP類別之屬性value的值
extension Array: Equatable { }

public func boardID(b: [[Int]]) -> Int {
	return Int(b.flatMap{ $0.flatMap{ String($0) } }.joinWithSeparator(""))!
}

/** 將數字陣列形式的拼圖轉換為易讀的拼圖形式顯示字串，以方便以print函式觀察結果
例如將陣列 [[1,2,3], [8,0,4], [7,6,5]]轉換後顯示為
[1,2,3]
[[1,2,3], [8,0,4], [7,6,5]]   =>	[8,0,4]
[7,6,5]
*/
public func board2str(b: [[Int]]) -> String {
	return b.flatMap{ String($0) }.joinWithSeparator("\n")
}
/// 根據拼圖盤面的狀況取得存在之相鄰節點 (往四個方向移動的可能性，加入節點之鄰居節點關係) moveable參數為可移動之圖塊
func addNeighbors(node: NodeP<[[Int]]>, moveable: Int = 0) {
	/// 定義方向的列舉
	enum Direction{
		case up, right, down, left
	}
	/// 尋找目標值(數字)在拼圖中(數字陣列形式)的位置
	func findXY() -> (x: Int, y: Int)? {
		let board = node.value
		for i in 0..<board.count {
			for j in 0..<board[0].count {
				if board[i][j] == moveable {
					return (x: i, y: j)
				}
			}
		}
		return nil
	}
	/// 若可移動，則將移動後的盤面加入為目前該節點的鄰居節點
	func moveAdd(dir: Direction) {
		let p1: (x: Int, y: Int) = (findXY()!.x, findXY()!.y)
		var p2: (x: Int, y: Int)
		switch dir {
		case .up:
			p2 = (p1.x - 1, p1.y)
		case .right:
			p2 = (p1.x, p1.y + 1)
		case .down:
			p2 = (p1.x + 1, p1.y)
		case .left:
			p2 = (p1.x, p1.y - 1)
		}
		guard (p2.0 >= 0 && p2.0 <= 2 && p2.1 >= 0 && p2.1 <= 2) else { return }
		var nboard = node.value
		swap(&nboard[p1.0][p1.1], &nboard[p2.0][p2.1])
		let newNodeP = NodeP(name: board2str(nboard), value: nboard)
		for neighbor in node.getChild() {
			if newNodeP == neighbor {
				return
			}
		}
		node.addChild(newNodeP)
	}
	moveAdd(.up)
	moveAdd(.down)
	moveAdd(.right)
	moveAdd(.left)
}

/// 定義追蹤歷程的字典型態
var parent: [String: String] = [:]
/// 定義搜尋深度的字典型態
public var level: [String: Int] = [:]
/// 追蹤搜尋的字串(用node的name來進行追蹤)
var nodestr: String? = nil
/// 廣度優先搜尋, moveable參數為可移動的圖塊編號, 預設值為0
public func bfs(g: [[Int]], inout q: Queue<NodeP<[[Int]]>>, moveable: Int = 0) -> Bool {
	guard !q.isEmpty else { return false }					// 如果 queue 已空，則返回。
	if let node = q.dequeue() {								// 否則、取出 queue 的第一個節點。
		nodestr = node.name
		guard !node.visited else { return false }			// 如果該節點拜訪過，繼續搜尋；否則，直接返回。
		node.visited = true									// 標示為已拜訪
		if node.value == g {
			print("Found solution @\n\(nodestr!)")			// 印出節點
			return true
		}
		addNeighbors(node, moveable: moveable)				// 計算鄰居並加入鄰居節點。
		//		let neighbors = node.getConn()						// 取出鄰居。
		let neighbors = node.getChild()						// 取出鄰居。
		if !neighbors.isEmpty {
			for rote in neighbors {							// 對於每個鄰居
				let nstr = board2str(rote.value)
				if !rote.visited {							// 假如該鄰居還沒被拜訪過
					parent[nstr] = nodestr					// 追蹤搜尋節點, 利用紀錄鄰居節點的來源節點為自己之特性追蹤
					level[nstr] = level[nodestr!]! + 1		// 追蹤搜尋節點的深度
					q.enqueue(rote)							// 就放入 queue 中
				}
			}
			bfs(g, q: &q, moveable: moveable)
		}
	}
	return true
}

public func backtrace(goal: [[Int]]) {
	print("======= backtrace =========")
	var nodestr: String? = board2str(goal)
	while (nodestr != nil) {
		print("Tracking Level:\n--- Level:\(level[nodestr!]!) ---")
		print(nodestr!, terminator: "\n\n")
		nodestr = parent[nodestr!]
	}
}
