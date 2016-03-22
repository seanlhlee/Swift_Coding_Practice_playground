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
public func board2str(b: [[Int]]) -> String {
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
public var level: [String: Int] = [:]
/// 追蹤搜尋的字串(用node的name來進行追蹤)
var nodestr: String? = nil
/// 廣度優先搜尋, moveable參數為可移動的圖塊編號, 預設值為0
public func bfs(g: [[Int]], inout q: Queue<Node<[[Int]]>>, moveable: Int = 0) -> Bool {
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

public func backtrace(goal: [[Int]]) {
	print("======= backtrace =========")
	var nodestr: String? = board2str(goal)
	while (nodestr != nil) {
		print("Tracking Level:\n--- Level:\(level[nodestr!]!) ---")
		print(nodestr!, terminator: "\n\n")
		nodestr = parent[nodestr!]
	}
}
