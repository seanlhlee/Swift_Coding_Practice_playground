import Foundation
import UIKit

func buildView(numberOfplates: Int) -> UIView {
	func buildPV() -> [UIView] {
		var plates: [Int] {
			return Array(1...numberOfplates)
		}
		return plates.flatMap{
			let view = UIView(frame: CGRect(origin: CGPoint(x: Double(numberOfplates - $0) * 5.0, y: 0.0), size: CGSize(width: Double($0) * 10.0, height: 5.0)))
			view.backgroundColor = UIColor.blueColor()
			return view
		}
	}
	var platesView: [UIView] = buildPV()
	let v = UIView(frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: Double(numberOfplates) * 12.0 * 3, height: Double(numberOfplates) * 10.0)))
	v.backgroundColor = UIColor.whiteColor()
	for i in 0..<3 {
		for j in 1...numberOfplates {
			let subView = UIView(frame: CGRect(x: i * numberOfplates * 12 + 2, y: j * 7 + 2, width: numberOfplates * 12 , height: 7))
			subView.backgroundColor = UIColor.whiteColor()
			if i == 0 {
				subView.addSubview(platesView[j - 1])
			}
			v.addSubview(subView)
		}
	}
	return v
}

public class TowerofHanoi {
	public var numberOfplates: Int
	public var view: UIView
	var grid: Array2D<UIView> {
		var grid2D: Array2D<UIView> = Array2D(columns: 3, rows: numberOfplates, initialValue: UIView())
		for i in 0..<3 {
			for j in 0..<numberOfplates {
				grid2D[i, j] = view.subviews[i * numberOfplates + j]
			}
		}
		return grid2D
	}
	public init(numberOfplates: Int) {
		self.numberOfplates = numberOfplates
		self.view = buildView(numberOfplates)
	}
	func move(from: UIView, to: UIView) {
		let sv = from.subviews[0]
		sv.removeFromSuperview()
		to.addSubview(sv)
	}
	public func move(f:(x: Int, y: Int), t:(x: Int, y: Int)) {
		move(grid[f.x,f.y], to: grid[t.x, t.y])
	}
}