import UIKit


public func boardView() -> UIView {
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
public func board2D(boardView: UIView) -> Array2D<UIView> {
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
public class Board {
	var bv: UIView
	var board: Array2D<UIView>
	public init() {
		self.bv = boardView()
		self.board = board2D(bv)
	}
	func chessImage(turn: Turn) -> UIImage {
		let name = turn == .User ? "black" : "white"
		return UIImage(named: name)!
	}
	public func putChess(x: Int, _ y: Int, turn: Turn) throws {
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
	public func winCheck(turn: Turn) -> Bool {
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
	public func computerTurn() throws {
		var best_r = 0, best_c = 0, best_score = -1
		for r in 1...16 {
			for c in 1...16 {
				guard self.board[r, c].subviews.isEmpty else { continue }
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
		print("best = \(best_score) @(\(best_r), \(best_c))")
		try! putChess(best_r, best_c, turn: .Com)			// 否則、將子下在使用者輸入的 (r,c) 位置
	}
}