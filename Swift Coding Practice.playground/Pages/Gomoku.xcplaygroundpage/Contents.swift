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
# 實作：五子棋程式

## 簡介

在本文中，我們設計了一個完全只是依賴「盤面評估函數」的五子棋程式，這個程式並沒有採用「Min-Max 對局搜尋法」，更沒有採用「Alpha-Beta 修剪法」，但是已經能夠與一般人對戰，有時候還可以贏得棋局。

以下是這個程式執行的一個畫面，我們採用命令列的設計方式，使用者下子時必須輸入格子的座標，該座標由兩個 16 進位字母組成，例如圖中的 62 代表下在第六列第二行的位置。

![](chess.jpg "")

圖、五子棋程式的一個對局畫面

## 程式實作

整個程式的實作只包含以下這個 chess.js 檔案，完整原始碼如下。

檔案：chess.js

	// 五子棋遊戲，單機命令列版
	//   人對人下：node chess P2P
	//   人對電腦：node chess P2C
	// 作者：陳鍾誠
	var util = require("util");
	var log = console.log;
	var r = require('readline').createInterface(process.stdin, process.stdout);

	// 印出訊息，並取得輸入。
	var prompt = function(turn) {
		var msg = format('將 %s 下在 :    ', turn);
		r.setPrompt(msg);
		r.prompt();
	}

	var format = function() { // 字串格式化
		return util.format.apply(null, arguments);
	}

	// 棋盤物件
	var Board = function() {
		this.m = [];
		for (var r=0; r<16; r++) {
			this.m[r] = [];
			for (var c=0; c<16; c++)
				this.m[r][c] = '-';
		}
	}

	// 將棋盤格式化成字串
	Board.prototype.toString = function() {
		var str = "  0 1 2 3 4 5 6 7 8 9 a b c d e f\n";
		for (var r=0; r<16; r++) {
			str += r.toString(16)+" "+this.m[r].join(" ")+" "+r.toString(16)+"\n";
		}
		str += "  0 1 2 3 4 5 6 7 8 9 a b c d e f\n";
		return str;
	}

	// 顯示棋盤
	Board.prototype.show = function() {
		log(this.toString());
	}

	// 以下為遊戲相關資料與函數
	// var zero = [ 0, 0, 0, 0, 0];
	// var inc  = [-2,-1, 0, 1, 2];
	// var dec  = [ 2, 1, 0,-1,-2];
	var z9   = [ 0, 0, 0, 0, 0, 0, 0, 0, 0];
	var i9   = [-4,-3,-2,-1, 0, 1, 2, 3, 4];
	var d9   = [ 4, 3, 2, 1, 0,-1,-2,-3,-4];
	var z5   = [ 0, 0, 0, 0, 0];
	var i2   = i9.slice(2,-2);
	var d2   = d9.slice(2,-2);

	// 檢查在 (r, c) 這一格，規則樣式 (dr, dc) 是否被滿足
	// dr, dc 的組合可用來代表「垂直 | , 水平 - , 下斜 \ , 上斜 /」。
	var patternCheck=function(board, turn, r, c, dr, dc) {
		for (var i = 0; i < dr.length; i++) {
			var tr = Math.round(r+dr[i]);
			var tc = Math.round(c+dc[i]);
			if (tr<0 ||tr > 15 || tc<0 || tc>15)
				return false;
			var v = board.m[tr][tc];
			if (v != turn) return false;
		}
		return true;
	}
	// 檢查是否下 turn 這個子的人贏了。
	var winCheck = function(board, turn) {
		var win = false;
		for (var r=0; r<16; r++) {
			for (var c=0; c<16; c++) {
			if (patternCheck(board, turn, r, c, z5, i2)) // 垂直 | ;
				win = true;
			if (patternCheck(board, turn, r, c, i2, z5)) // 水平 - ;
				win = true;
			if (patternCheck(board, turn, r, c, i2, i2)) // 下斜 \ ;
				win = true;
			if (patternCheck(board, turn, r, c, i2, d2)) // 上斜 / ;
				win = true;
			}
		}
		if (win) {
			log("%s 贏了！", turn);  // 如果贏了就印出贏了
			process.exit(0); // 然後離開。
		}
		return win;
	}

	var peopleTurn = function(board, turn, line) {
		var r = parseInt(line[0], 16); // 取得下子的列 r (row)
		var c = parseInt(line[1], 16); // 取得下子的行 c (column)
		if (r<0 || r>15 || c<0 || c>15) // 檢查是否超出範圍
			throw "(row, col) 超出範圍!"; // 若超出範圍就丟出例外，下一輪重新輸入。
		if (board.m[r][c] != '-') // 檢查該位置是否已被佔據
			throw format("(%s%s) 已經被佔領了!", line[0], line[1]); // 若被佔據就丟出例外，下一輪重新輸入。
		board.m[r][c] = turn; // 否則、將子下在使用者輸入的 (r,c) 位置
	}

	var P2P=function(b, turn, line) {
		peopleTurn(b, turn, line);
		b.show();         // 顯示棋盤現況
		winCheck(b, turn);
		return (turn == 'o')?'x':'o'; // 換對方下了。
	}

	var attackScores = [ 0, 3, 10, 30, 100, 500 ];
	var guardScores  = [ 0, 2,  9, 25,  90, 400 ];
	var attack=1, guard=2;

	var getScore = function(board, r, c, turn, mode) {
		var score = 0;
		var mScores = (mode === attack)?attackScores:guardScores;
		board.m[r][c] = turn;
		for (var start = 0; start <= 4; start++) {
			for (var len = 5; len >= 1; len--) {
				var end = start+len;
				var zero = z9.slice(start, start+len);
				var inc  = i9.slice(start, start+len);
				var dec  = d9.slice(start, start+len);
				if (patternCheck(board, turn, r, c, zero, inc)) // 攻擊：垂直 | ;
					score += mScores[len];
				if (patternCheck(board, turn, r, c, inc, zero)) // 攻擊：水平 - ;
					score += mScores[len];
				if (patternCheck(board, turn, r, c, inc, inc)) // 攻擊：下斜 \ ;
					score += mScores[len];
				if (patternCheck(board, turn, r, c, inc, dec)) // 攻擊：上斜 / ;
					score += mScores[len];
			}
		}
		board.m[r][c] = '-';
		return score;
	}

	var computerTurn = function(board, turn) {
		var best = { r:0, c:0, score:-1 };
		for (var r=0; r<=15; r++) {
			for (var c=0; c<=15; c++) {
				if (board.m[r][c] !== '-')
					continue;
				var attackScore = getScore(board, r, c, 'x', attack);  // 攻擊分數
				var guardScore  = getScore(board, r, c, 'o', guard);   // 防守分數
				var score = attackScore+guardScore;
				if (score > best.score) {
					best.r = r;
					best.c = c;
					best.score = score;
				}
			}
		}
		log("best=%j", best);
		board.m[best.r][best.c] = turn; // 否則、將子下在使用者輸入的 (r,c) 位置
	}

	var P2C=function(b, turn, line) {
		peopleTurn(b, 'o', line);
		b.show();         // 顯示棋盤現況
		winCheck(b, 'o'); // 檢查下了這子之後是否贏了！
		computerTurn(b, 'x', line);
		b.show();
		winCheck(b, 'x');
		return 'o';
	}

	var chess=function(doLine) {
		// 主程式開始
		var b = new Board(); // 建立棋盤
		b.show();            // 顯示棋盤
		var turn = 'o';      // o 先下
		prompt(turn);        // 提示要求下子訊息，並接受輸入。
		r.on('line', function(line) { // 每當讀到一個字串時。
			try {
				turn = doLine(b, turn, line);
			} catch (err) { // 若有丟出例外
				log(err); // 則印出錯誤訊息。
			}
			prompt(turn); // 提示要求下子訊息，並接受輸入。
		}).on('close', function() { // 輸入結束了
			process.exit(0); // 程式結束。
		});
	}

	if (process.argv[2] === "P2P") // 人對人下
		chess(P2P);
	else if (process.argv[2] === "P2C") // 人對電腦下
		chess(P2C);
	else { // 命令下錯，提示訊息！
		log("人對人下：node chess P2P\n人對電腦：node chess P2C");
		process.exit(0);
	}
*/
import UIKit
// /*   遊戲的實作可以mark起來, 以測試遊戲進行 (Board class已定義於Sources資料夾)

func boardView() -> UIView {
	let boardView = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 540.0, height: 540.0)))
	boardView.backgroundColor = UIColor.blackColor()
	var x: CGFloat
	var y: CGFloat
	for i in 0..<18 {
		for j in 0..<18 {
			x = 30.0 * CGFloat(i)
			y = 30.0 * CGFloat(j)
			let grid = (i == 0 || i == 17 || j == 0 || j == 17) ? UIView(frame: CGRect(origin: CGPoint(x: x,y: y), size: CGSize(width: 30.0, height: 30.0))) : UIView(frame: CGRect(origin: CGPoint(x: x + 1,y: y + 1), size: CGSize(width: 28.0, height: 28.0)))
			if Int(i + j) % 2 == 0 && i != 0 && i != 17 && j != 0 && j != 17 {
				grid.backgroundColor = UIColor.brownColor()
			} else if (i == 0 && j != 0 && j != 17) || (i == 17 && j != 0 && j != 17) {
				let label = UILabel(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 30.0, height: 30.0)))
				label.text = "\(j)"
				label.textAlignment = NSTextAlignment.Center
				grid.addSubview(label)
				grid.addSubview(label)
				grid.backgroundColor = UIColor.whiteColor()
			} else if (j == 0 && i != 0 && i != 17) || (j == 17 && i != 0 && i != 17) {
				let label = UILabel(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 30.0, height: 30.0)))
				label.text = "\(i)"
				label.textAlignment = NSTextAlignment.Center
				grid.addSubview(label)
				grid.backgroundColor = UIColor.whiteColor()
			} else {
				grid.backgroundColor = UIColor.whiteColor()
			}
			boardView.addSubview(grid)
		}
		
	}
	return boardView
}
func board2D(boardView: UIView) -> Array2D<UIView> {
	var board2D: Array2D<UIView> = Array2D(columns: 18, rows: 18, initialValue: UIView())
	for i in 0..<18 {
		for j in 0..<18 {
			board2D[i, j] = boardView.subviews[i * 18 + j]
		}
	}
	return board2D
}
public enum Turn: CustomStringConvertible {
	case User, Com
	public var description: String {
		switch self {
		case .User:
			return "User"
		case .Com:
			return "Com"
		}
	}
}
public enum ChessError: ErrorType {
	case OutBound, CantPut
}
public enum Mode {
	case Attack, Guard
}
public enum Direction {
	case Horizontal, Vertical, LURD, LDRU
}
public enum ChessType: String {
	case White = "white", Black = "black"
	func imageSet() -> UIImage {
		return UIImage(named: rawValue)!
	}
}

public class Board {
	var bv: UIView
	var board: Array2D<UIView>
	var userChess: ChessType
	var comChess: ChessType {
		return userChess == .Black ? .White : .Black
	}
	var vsGame: Bool = true
	public init() {
		self.bv = boardView()
		self.board = board2D(bv)
		self.userChess = .Black
		self.vsGame = true
	}
	public func setChess(userChess: ChessType) {
		self.userChess = userChess
	}
	public func setChess(userBlack: Bool) {
		self.userChess = userBlack ? .Black : .White
	}
	func chessImage(turn: Turn) -> UIImage {
		return turn == .User ? userChess.imageSet() : comChess.imageSet()
	}
	func putChess(x: Int, _ y: Int, turn: Turn = .User) throws {
		guard x >= 0 && x <= 16 && y >= 0 && y <= 16 else { throw ChessError.OutBound }
		guard board[x, y].subviews.isEmpty else { throw ChessError.CantPut }
		let chessImageView = UIImageView(image: chessImage(turn))
		board[x, y].addSubview(chessImageView)
	}
	func patternCheck(r: Int, _ c: Int, _ dr: [Int], _ dc: [Int], turn: Turn) -> Bool {
		for i in 0..<dr.count {
			let tr = r + dr[i]
			let tc = c + dc[i]
			guard (tr >= 1 && tr <= 16 && tc >= 1 && tc <= 16) else { return false }
			guard (!board[tr, tc].subviews.isEmpty) else { return false }
			if let iv = board[tr, tc].subviews[0] as? UIImageView {
				guard (iv.image == chessImage(turn)) else { return false }
			}
		}
		return true
	}
	func user(x: Int, y: Int) throws -> Bool {
		do {
			try putChess(x, y, turn: .User)
		} catch ChessError.OutBound {
			print("超出邊界")
			return true
		} catch ChessError.CantPut {
			print("這裡不能下子")
			return true
		}
		
		return winCheck(.User)
	}
	public func user(x: Int, _ y: Int) -> Bool? {
		if let b = try? user(x, y: y) {
			guard !b else { return true }
			try! computerTurn()
		}
		return false
	}
	func winCheck(turn: Turn) -> Bool {
		let z5 = [ 0, 0, 0, 0, 0]
		let i2 = [-2,-1, 0, 1, 2]
		let d2 = [ 2, 1, 0,-1,-2]
		for x in 1...16 {
			for y in 1...16 {
				if	patternCheck(x, y, z5, i2, turn: turn)	||
					patternCheck(x, y, i2, z5, turn: turn)	||
					patternCheck(x, y, i2, i2, turn: turn)	||
					patternCheck(x, y, i2, d2, turn: turn)	{
					print("\(turn.description)贏了")
					return true
				}
			}
		}
		return false
	}
	public func getView() -> UIView {
		return bv
	}
	func getScore(r: Int, _ c: Int, _ turn: Turn, mode: Mode) throws -> Int {
		try putChess(r, c, turn: turn)
		let attackScores = [ 0, 3, 10, 30, 100, 500 ]
		let guardScores  = [ 0, 2,  9, 25,  90, 400 ]
		var score = 0
		var mScores = (mode == .Attack) ? attackScores : guardScores
		var len: Int = 0
		for start in 0..<5 {
			for l in -5..<0 {
				len = -l
				let end = start + len
				let zero = Array([ 0, 0, 0, 0, 0, 0, 0, 0, 0][start..<end])
				let inc  = Array([-4,-3,-2,-1, 0, 1, 2, 3, 4][start..<end])
				let dec  = Array([ 4, 3, 2, 1, 0,-1,-2,-3,-4][start..<end])
				if (patternCheck(r, c, zero, inc, turn: turn)) {	// 攻擊：垂直 | ;
					score += mScores[len]
				}
				if (patternCheck(r, c, inc, zero, turn: turn)) { // 攻擊：水平 - ;
					score += mScores[len]
				}
				if (patternCheck(r, c, inc, inc, turn: turn)) { // 攻擊：下斜 \ ;
					score += mScores[len]
				}
				if (patternCheck(r, c, inc, dec, turn: turn)) { // 攻擊：上斜 / ;
					score += mScores[len]
				}
			}
		}
		board[r,c].subviews[0].removeFromSuperview()
		return score
	}
	func computerTurn() throws {
		var best_r = 0, best_c = 0, best_score = -1
		var isBlank: Bool = true
		for r in 1...16 {
			for c in 1...16 {
				guard self.board[r, c].subviews.isEmpty else {
					isBlank = false
					continue
				}
				let attackScore = try getScore(r, c, .Com, mode: .Attack)	// 攻擊分數
				let guardScore  = try getScore(r, c, .User, mode: .Guard)	// 防守分數
				let score = attackScore + guardScore
				if score > best_score {
					best_r = r
					best_c = c
					best_score = score
				}
			}
		}
		var array = [6,7,8,9,10,11]
		if isBlank {
			try! putChess(array[Int(arc4random_uniform(5))], array[Int(arc4random_uniform(6))], turn: .Com)
		} else {
			print("best = \(best_score) @(\(best_r), \(best_c))")
			try! putChess(best_r, best_c, turn: .Com)			// 否則、將子下在使用者輸入的 (r,c) 位置
		}
		if !winCheck(.Com) {
			if !self.vsGame {
				try! userTurn()
			}
		}
	}
	func userTurn() throws {
		guard !self.vsGame else { return }
		var best_r = 0, best_c = 0, best_score = -1
		for r in 1...16 {
			for c in 1...16 {
				guard self.board[r, c].subviews.isEmpty else { continue }
				let attackScore = try getScore(r, c, .User, mode: .Attack)	// 攻擊分數
				let guardScore  = try getScore(r, c, .Com, mode: .Guard)	// 防守分數
				let score = attackScore + guardScore
				if score > best_score {
					best_r = r
					best_c = c
					best_score = score
				}
			}
		}
		print("best = \(best_score) @(\(best_r), \(best_c))")
		try! putChess(best_r, best_c, turn: .User)			// 否則、將子下在使用者輸入的 (r,c) 位置
		if !winCheck(.User) {
			try! computerTurn()
		}
	}
	public func play(first: Turn, vsGame: Bool = false) {
		self.vsGame = vsGame
		if vsGame {
			if first == .User {
				print("提示: 以user(x: Int, _ y: Int)開始下棋\n 例如user(5,7)")
			} else {
				try! computerTurn()
			}
		} else {
			if first == .User {
				try! userTurn()
			} else {
				try! computerTurn()
			}
		}
	}
	public func play(userFirst userFirst: Bool, vsGame: Bool = false) {
		if userFirst {
			play(.User, vsGame: vsGame)
		} else {
			play(.Com, vsGame: vsGame)
		}
	}
}
// */

// preparation for play
let game = Board()
game.setChess(ChessType.White)
var view = game.getView()
func user(x: Int, _ y: Int) {
	game.user(x,y)
}

// 遊戲開始
// 1. 以電腦取代player下棋
//game.play(userFirst: true)
//view

//// 2. 與電腦對戰，電腦先下棋(輸入user(x,y)下子)
game.play(userFirst: false, vsGame: true)
//user(6,7)
//user(7,5)
//user(8,4)
//user(1,5)
//user(6,4)
//user(8,6)
//user(6,5)
//user(6,3)
//user(8,5)
//user(7,7)
//user(6,5)
//user(5,5)
//user(4,4)
//user(3,3)
//
view


// 3. 與電腦對戰，user先下棋(輸入user(x,y)下子)
//game.play(userFirst: true, vsGame: true)
//user(6,6)
//user(7,5)
//user(7,6)
//user(8,6)
//user(5,6)
//user(6,4)
//user(8,7)
//user(6,5)
//user(9,5)
//user(6,3)
//user(5,4)
//user(7,4)
//user(7,2)
//user(4,5)
//user(3,6)
//view

/*:


## 執行結果

以下是一場對局的過程片段，您可以看到最後是 x 贏了，也就是人類贏了。

	C:\Dropbox\Public\web\ai\code\chess>node chess P2C
	0 1 2 3 4 5 6 7 8 9 a b c d e f
	0 - - - - - - - - - - - - - - - - 0
	1 - - - - - - - - - - - - - - - - 1
	2 - - - - - - - - - - - - - - - - 2
	3 - - - - - - - - - - - - - - - - 3
	4 - - - - - - - - - - - - - - - - 4
	5 - - - - - - - - - - - - - - - - 5
	6 - - - - - - - - - - - - - - - - 6
	7 - - - - - - - - - - - - - - - - 7
	8 - - - - - - - - - - - - - - - - 8
	9 - - - - - - - - - - - - - - - - 9
	a - - - - - - - - - - - - - - - - a
	b - - - - - - - - - - - - - - - - b
	c - - - - - - - - - - - - - - - - c
	d - - - - - - - - - - - - - - - - d
	e - - - - - - - - - - - - - - - - e
	f - - - - - - - - - - - - - - - - f
	0 1 2 3 4 5 6 7 8 9 a b c d e f

	將 o 下在 : 66
	0 1 2 3 4 5 6 7 8 9 a b c d e f
	0 - - - - - - - - - - - - - - - - 0
	1 - - - - - - - - - - - - - - - - 1
	2 - - - - - - - - - - - - - - - - 2
	3 - - - - - - - - - - - - - - - - 3
	4 - - - - - - - - - - - - - - - - 4
	5 - - - - - - - - - - - - - - - - 5
	6 - - - - - - o - - - - - - - - - 6
	7 - - - - - - - - - - - - - - - - 7
	8 - - - - - - - - - - - - - - - - 8
	9 - - - - - - - - - - - - - - - - 9
	a - - - - - - - - - - - - - - - - a
	b - - - - - - - - - - - - - - - - b
	c - - - - - - - - - - - - - - - - c
	d - - - - - - - - - - - - - - - - d
	e - - - - - - - - - - - - - - - - e
	f - - - - - - - - - - - - - - - - f
	0 1 2 3 4 5 6 7 8 9 a b c d e f

	best={"r":6,"c":7,"score":31}
	0 1 2 3 4 5 6 7 8 9 a b c d e f
	0 - - - - - - - - - - - - - - - - 0
	1 - - - - - - - - - - - - - - - - 1
	2 - - - - - - - - - - - - - - - - 2
	3 - - - - - - - - - - - - - - - - 3
	4 - - - - - - - - - - - - - - - - 4
	5 - - - - - - - - - - - - - - - - 5
	6 - - - - - - o x - - - - - - - - 6
	7 - - - - - - - - - - - - - - - - 7
	8 - - - - - - - - - - - - - - - - 8
	9 - - - - - - - - - - - - - - - - 9
	a - - - - - - - - - - - - - - - - a
	b - - - - - - - - - - - - - - - - b
	c - - - - - - - - - - - - - - - - c
	d - - - - - - - - - - - - - - - - d
	e - - - - - - - - - - - - - - - - e
	f - - - - - - - - - - - - - - - - f
	0 1 2 3 4 5 6 7 8 9 a b c d e f

	...

	best={"r":6,"c":3,"score":144}
	0 1 2 3 4 5 6 7 8 9 a b c d e f
	0 - - - - - - - - - - - - - - - - 0
	1 - - - - - - - - - - - - - - - - 1
	2 - - - - - - - - - - - - - - - - 2
	3 - - - - - - - - - - - - - - - - 3
	4 - - - - x - - - - - - - - - - - 4
	5 - - - - - o - - - - - - - - - - 5
	6 - - - x o o o x - - - - - - - - 6
	7 - - - - - - - o - - - - - - - - 7
	8 - - - - - - - - x - - - - - - - 8
	9 - - - - - - - - - x - - - - - - 9
	a - - - - - - - - - - - - - - - - a
	b - - - - - - - - - - - - - - - - b
	c - - - - - - - - - - - - - - - - c
	d - - - - - - - - - - - - - - - - d
	e - - - - - - - - - - - - - - - - e
	f - - - - - - - - - - - - - - - - f
	0 1 2 3 4 5 6 7 8 9 a b c d e f
	...

	0 1 2 3 4 5 6 7 8 9 a b c d e f
	0 - - - - - - - - - - - - - - - - 0
	1 - - - - - - - - - - - - - - - - 1
	2 - - - - - - - - - - - - - - - - 2
	3 - - - - - - - - - - - - - - - - 3
	4 - - - - x - - - - - - - - - - - 4
	5 - - o - - o - - - - - - - - - - 5
	6 - - o x o o o x - - - - - - - - 6
	7 - - - - x o o o - - - - - - - - 7
	8 - - - - - x - - x - - - - - - - 8
	9 - - - - - - x - - x - - - - - - 9
	a - - - - - - - x - - - - - - - - a
	b - - - - - - - - - - - - - - - - b
	c - - - - - - - - - - - - - - - - c
	d - - - - - - - - - - - - - - - - d
	e - - - - - - - - - - - - - - - - e
	f - - - - - - - - - - - - - - - - f
	0 1 2 3 4 5 6 7 8 9 a b c d e f

	x 贏了！

## 參考文獻

維基百科：[五子棋](http://zh.wikipedia.org/zh-tw/五子棋)

*****
[Next](@next)
*/
