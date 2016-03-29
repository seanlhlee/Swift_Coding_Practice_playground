import Foundation
import UIKit

enum GridType: String {
	case White, Red
	func imageSet() -> UIImage {
		return UIImage(named: rawValue)!
	}
}

public class Grid {
	var gv: UIView
	var grid: Array2D<UIView>
	public init() {
		func gridView() -> UIView {
			let gridView = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 540.0, height: 540.0)))
			gridView.backgroundColor = UIColor.blackColor()
			var x: CGFloat
			var y: CGFloat
			for i in 0..<54 {
				for j in 0..<54 {
					x = 10.0 * CGFloat(i)
					y = 10.0 * CGFloat(j)
					let grid = (i == 0 || i == 53 || j == 0 || j == 53) ? UIView(frame: CGRect(origin: CGPoint(x: x,y: y), size: CGSize(width: 10.0, height: 10.0))) : UIView(frame: CGRect(origin: CGPoint(x: x + 1,y: y + 1), size: CGSize(width: 8.0, height: 8.0)))
					if i != 0 && i != 53 && j != 0 && j != 53 {
						grid.backgroundColor = UIColor.grayColor()
					} else if (i == 0 && j != 0 && j != 53) || (i == 53 && j != 0 && j != 53) {
						grid.backgroundColor = UIColor.whiteColor()
					} else if (j == 0 && i != 0 && i != 53) || (j == 53 && i != 0 && i != 53) {
						grid.backgroundColor = UIColor.whiteColor()
					} else {
						grid.backgroundColor = UIColor.whiteColor()
					}
					gridView.addSubview(grid)
				}
				
			}
			return gridView
		}
		func grid2D(gridView: UIView) -> Array2D<UIView> {
			var grid2D: Array2D<UIView> = Array2D(columns: 54, rows: 54, initialValue: UIView())
			for i in 0..<54 {
				for j in 0..<54 {
					grid2D[i, j] = gridView.subviews[i * 54 + j]
				}
			}
			return grid2D
		}
		self.gv = gridView()
		self.grid = grid2D(gv)
	}
	public func getView() -> UIView {
		return gv
	}
	public func getGrid() -> Array2D<UIView> {
		return grid
	}
	public func setAnt(x: Int, _ y: Int) {
		guard x > 0 && x < 54 && y > 0 && y < 54 else { return }
		let ant = UIImageView(image: UIImage(named: "ant_s"))
		self.grid[x,y].addSubview(ant)
	}
}