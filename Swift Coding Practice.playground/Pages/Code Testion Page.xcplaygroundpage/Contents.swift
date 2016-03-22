//: [Previous](@previous)
import Foundation
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


/// 多層感知層之神經網路測試
/*
var pat: [[[Double]]] = [
	// A B C D E F G
	[[1,1,1,1,1,1,0], [0,0,0,0]], // 0
	[[0,1,1,0,0,0,0], [0,0,0,1]], // 1
	[[1,1,0,1,1,0,1], [0,0,1,0]], // 2
	[[1,1,1,1,0,0,1], [0,0,1,1]], // 3
	[[0,1,1,0,0,1,1], [0,1,0,0]], // 4
	[[1,0,1,1,0,1,1], [0,1,0,1]], // 5
	[[1,0,1,1,1,1,1], [0,1,1,0]], // 6
	[[1,1,1,0,0,0,0], [0,1,1,1]], // 7
	[[1,1,1,1,1,1,1], [1,0,0,0]], // 8
	[[1,1,1,1,0,1,1], [1,0,0,1]], // 9
]

// create a network with 7 input, 5 hidden, and 4 output nodes
var nn = NeuralNet(ni: 7, nh: 5, no: 4);
// train it with some patterns
nn.train(pat, iterations: 10000, rate: 0.2, moment: 0.01)
// test it
nn.test(pat)

nn.update([1,0,1,1,0,1,1])
nn.update([1,0,0,1,1,1,0])   //input 圖形C
nn.outputCharacter([1,0,1,1,0,1,1])		//會
nn.outputCharacter([1,0,0,1,1,1,0])		//不會
nn.outputCharacter([1,0,0,0,1,1,1])		//不會

pat = [
	//A B C D E F G
	[[1,1,1,1,1,1,0], [0,0,0,0]], // 0
	[[0,1,1,0,0,0,0], [0,0,0,1]], // 1
	[[1,1,0,1,1,0,1], [0,0,1,0]], // 2
	[[1,1,1,1,0,0,1], [0,0,1,1]], // 3
	[[0,1,1,0,0,1,1], [0,1,0,0]], // 4
	[[1,0,1,1,0,1,1], [0,1,0,1]], // 5
	[[1,0,1,1,1,1,1], [0,1,1,0]], // 6
	[[1,1,1,0,0,0,0], [0,1,1,1]], // 7
	[[1,1,1,1,1,1,1], [1,0,0,0]], // 8
	[[1,1,1,1,0,1,1], [1,0,0,1]], // 9
	[[1,1,1,0,1,1,1], [1,0,1,0]], // A
	[[0,0,1,1,1,1,1], [1,0,1,1]], // B
	[[1,0,0,1,1,1,0], [1,1,0,0]], // C
	[[0,1,1,1,1,0,1], [1,1,0,1]], // D
	[[1,0,0,1,1,1,1], [1,1,1,0]], // E
	[[1,0,0,0,1,1,1], [1,1,1,1]], // F
]

nn = NeuralNet(ni: 7, nh: 5, no: 4);
nn.train(pat, iterations: 10000, rate: 0.2, moment: 0.01)
nn.test(pat)
nn.update([1,0,1,1,0,1,1])
nn.update([1,0,0,1,1,1,0])
nn.outputCharacter([1,0,1,1,0,1,1])		//會			5
nn.outputCharacter([1,0,0,1,1,1,0])		//學會了     C
nn.outputCharacter([1,0,0,0,1,1,1])		//學會了     F

*/
//: [Next](@next)
