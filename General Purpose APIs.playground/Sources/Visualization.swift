import UIKit

private enum Theme {
	enum Color {
		static let border = UIColor(red: 184/255.0, green: 201/255.0, blue: 238/255.0, alpha: 1)
		static let shade = UIColor(red: 227/255.0, green: 234/255.0, blue: 249/255.0, alpha: 1)
		static let highlight = UIColor(red: 14/255.0, green: 114/255.0, blue: 199/255.0, alpha: 1)
	}
	enum Font {
		static let codeVoice = UIFont(name: "Menlo-Regular", size: 14)!
	}
}

private struct StyledString {
	let string: String
	let shaded: Bool
	let highlighted: Bool
	let bordered: Bool
}

private extension UILabel {
	convenience init(styledString: StyledString) {
		self.init()
		text = styledString.string
		textAlignment = .Center
		font = Theme.Font.codeVoice
		textColor = styledString.highlighted ? Theme.Color.highlight : UIColor.blackColor()
		backgroundColor = styledString.shaded ? Theme.Color.shade : UIColor.whiteColor()
		if (styledString.bordered) {
			layer.borderColor = Theme.Color.border.CGColor
			layer.borderWidth = 1.0
		}
	}
}

public func visualize(str: String) -> UIView {
	return _visualize(str, range: nil)
}

public func visualize(str: String, index: String.Index) -> UIView {
	return _visualize(str, range: index...index)
}

public func visualize(str: String, range: Range<String.Index>) -> UIView {
	return _visualize(str, range: range)
}

private func _visualize(str: String, range: Range<String.Index>?) -> UIView {
	let stringIndices = str.characters.indices
	
	let styledCharacters = zip(stringIndices, str.characters).map { (characterIndex, char) -> StyledString in
		let shaded: Bool
		if let range = range where range.contains(characterIndex) {
			shaded = true
		} else {
			shaded = false
		}
		return StyledString(string: String(char), shaded: shaded, highlighted: false, bordered: true)
	}
	
	let characterLabels = styledCharacters.map { UILabel(styledString: $0) }
	
	let styledIndexes = (0..<stringIndices.count).map { index -> StyledString in
		let characterIndex = str.startIndex.advancedBy(index)
		
		let highlighted: Bool
		if let range = range where range.startIndex == characterIndex || range.last == characterIndex {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledString(string: String(index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let indexLabels = styledIndexes.map { UILabel(styledString: $0) }
	
	let charStacks: [UIStackView] = zip(characterLabels, indexLabels).map { (charLabel, indexLabel) in
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillEqually
		stack.addArrangedSubview(indexLabel)
		stack.addArrangedSubview(charLabel)
		return stack
	}
	
	let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 25 * charStacks.count, height: 50))
	stackView.distribution = .FillEqually
	charStacks.forEach(stackView.addArrangedSubview)
	
	return stackView
}

public let messageDates = [
	NSDate().dateByAddingTimeInterval(-2000),
	NSDate().dateByAddingTimeInterval(-1500),
	NSDate().dateByAddingTimeInterval(-500),
	NSDate()
]

private struct StyledArray {
	typealias T = Any
	let array: Array<T>
	let shaded: Bool
	let highlighted: Bool
	let bordered: Bool
}

private extension UILabel {
	convenience init(styledArray: StyledArray) {
		self.init()
		text = styledArray.array.count == 1 ? "\(styledArray.array[0])" : styledArray.array.description
		textAlignment = .Center
		font = Theme.Font.codeVoice
		textColor = styledArray.highlighted ? Theme.Color.highlight : UIColor.blackColor()
		backgroundColor = styledArray.shaded ? Theme.Color.shade : UIColor.whiteColor()
		if (styledArray.bordered) {
			layer.borderColor = Theme.Color.border.CGColor
			layer.borderWidth = 1.0
		}
	}
}

private extension Array{
	func indexIsValid(range: Range<Int>) -> Bool {
		return range.startIndex >= startIndex && range.startIndex <= endIndex && range.endIndex >= startIndex && range.endIndex <= endIndex
	}
}

public func visualize<T>(arr: Array<T>) -> UIView {
	return _visualize(arr, range: nil)
}

public func visualize<T>(arr: Array<T>, index: Int) -> UIView {
	guard arr.indexIsValid(index...index) else { fatalError("Index out of range") }
	return _visualize(arr, range: index...index)
}

public func visualize<T>(arr: Array<T>, range: Range<Int>) -> UIView {
	guard arr.indexIsValid(range) else { fatalError("Index out of range") }
	return _visualize(arr, range: range)
}


private func _visualize<T>(arr: Array<T>, range: Range<Int>?) -> UIView {
	let arrayIndices = arr.indices
	
	let styledElements = zip(arrayIndices, arr).map { (elementIndex, element) -> StyledArray in
		let shaded: Bool
		if let range = range where range.contains(elementIndex) {
			shaded = true
		} else {
			shaded = false
		}
		return StyledArray(array: Array(arrayLiteral: element), shaded: shaded, highlighted: false, bordered: true)
	}
	
	let elementLabels = styledElements.map { UILabel(styledArray: $0) }
	
	let styledIndexes = (0..<arrayIndices.count).map { index -> StyledArray in
		let highlighted: Bool
		if let range = range where range.startIndex == index || range.last == index {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledArray(array: Array(arrayLiteral: index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let indexLabels = styledIndexes.map { UILabel(styledArray: $0) }
	
	let elementStacks: [UIStackView] = zip(elementLabels, indexLabels).map { (elementLabel, indexLabel) in
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillEqually
		stack.addArrangedSubview(indexLabel)
		stack.addArrangedSubview(elementLabel)
		return stack
	}
	
	let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 125 * elementStacks.count, height: 50))
	stackView.distribution = .FillEqually
	elementStacks.forEach(stackView.addArrangedSubview)
	
	return stackView
}

private extension Array2D {
	func getIndices(row row: Int) -> [Int]  {
		return _getIndices(row...row, colRange: nil)
	}
	func getIndices(column col: Int) -> [Int]  {
		return _getIndices(nil, colRange: col...col)
	}
	func getIndices(row row: Int, col: Int) -> [Int]  {
		return _getIndices(row...row, colRange: col...col)
	}
	private func _getIndices(rowRange: Range<Int>? ,colRange: Range<Int>?) -> [Int] {
		guard _indexIsValid(rowRange, colRange: colRange) else { fatalError("Index out of range") }
		let rows: Range<Int> = rowRange != nil ? rowRange! : rowIndices
		let cols: Range<Int> = colRange != nil ? colRange! : colIndices
		var array = [Int]()
		for row in rows {
			for col in cols {
				array.append(row * columns + col)
			}
		}
		return array
	}
}

public func visualize<T>(arr2D: Array2D<T>) -> UIView {
	return _visualize(arr2D, rowRange: nil, colRange: nil)
}

public func visualize<T>(arr2D: Array2D<T>, row: Int) -> UIView {
	return _visualize(arr2D, rowRange: row...row, colRange: nil)
}

public func visualize<T>(arr2D: Array2D<T>, col: Int) -> UIView {
	return _visualize(arr2D, rowRange: nil, colRange: col...col)
}

private func _visualize<T>(arr2D: Array2D<T>, rowRange: Range<Int>? ,colRange: Range<Int>?) -> UIView {
	guard arr2D._indexIsValid(rowRange, colRange: colRange) else { fatalError("Index out of range") }
	let arrayIndices = arr2D.array.indices
	let rangeIndices = (rowRange == nil && colRange == nil) ? [Int]() : arr2D._getIndices(rowRange, colRange: colRange)
	let styledElements = zip(arrayIndices, arr2D.array).map { (elementIndex, element) -> StyledArray in
		let shaded: Bool
		if rangeIndices.contains(elementIndex) {
			shaded = true
		} else {
			shaded = false
		}
		return StyledArray(array: Array(arrayLiteral: element), shaded: shaded, highlighted: false, bordered: true)
	}
	
	let elementLabels = styledElements.map { UILabel(styledArray: $0) }
	
	let styledRowIndexes = arr2D.rowIndices.map { index -> StyledArray in
		let highlighted: Bool
		if let range = rowRange where range.contains(index) {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledArray(array: Array(arrayLiteral: index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let styledColumnIndexes = arr2D.colIndices.map { index -> StyledArray in
		let highlighted: Bool
		if let range = colRange where range.contains(index) {
			highlighted = true
		} else {
			highlighted = false
		}
		
		return StyledArray(array: Array(arrayLiteral: index), shaded: false, highlighted: highlighted, bordered: false)
	}
	
	let indexRowLabels = styledRowIndexes.map { UILabel(styledArray: $0) }
	let indexColumnLabels = styledColumnIndexes.map { UILabel(styledArray: $0) }
	
	let indexLabels = [UILabel()] + indexColumnLabels
	let contentLabels = arr2D.rowIndices.map{ [indexRowLabels[$0]] + Array(elementLabels[$0 * arr2D.columns..<$0 * arr2D.columns + arr2D.columns]) }
	let elementStacks: [UIStackView] = indexLabels.indices.map { (index) in
		let stack = UIStackView()
		stack.axis = .Vertical
		stack.distribution = .FillEqually
		stack.addArrangedSubview(indexLabels[index])
		arr2D.rowIndices.forEach{stack.addArrangedSubview(contentLabels[$0][index])}
		return stack
	}
	
	let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 125 * elementStacks.count, height: 50 * (indexRowLabels.count + 1)))
	stackView.distribution = .FillEqually
	elementStacks.forEach(stackView.addArrangedSubview)
	
	return stackView
}

public protocol Visualization {
	associatedtype Index
	func visualizeView() -> UIView
}

extension String: Visualization {
	public func visualizeView() -> UIView {
		return visualize(self)
	}
	public func visualizeView(idx: Int) -> UIView {
		let index = self.startIndex.advancedBy(idx, limit: endIndex)
		return visualize(self, index: index)
	}
	public func visualizeView(range: Range<Int>) -> UIView {
		let strRange = self.startIndex.advancedBy(range.startIndex)..<self.startIndex.advancedBy(range.endIndex)
		return visualize(self, range: strRange)
	}
}

extension Array: Visualization {
	public func visualizeView() -> UIView {
		return visualize(self)
	}
	public func visualizeView(index idx: Int) -> UIView {
		return visualize(self, index: idx)
	}
	public func visualizeView(range range: Range<Int>) -> UIView {
		return visualize(self, range: range)
	}
}

extension Array2D: Visualization {
	public typealias Index = Int
	public func visualizeView() -> UIView {
		return visualize(self)
	}
	public func visualizeView(row row: Int) -> UIView {
		return visualize(self, row: row)
	}
	public func visualizeView(column col: Int) -> UIView {
		return visualize(self, col: col)
	}
}

extension Vector2D: Visualization {
	public typealias Index = Int
	public func visualizeView() -> UIView {
		return self.arrayForm.visualizeView()
	}
}

extension Vector3D: Visualization {
	public typealias Index = Int
	public func visualizeView() -> UIView {
		return self.arrayForm.visualizeView()
	}
}

extension Matrix: Visualization {
	public func visualizeView() -> UIView {
		return self.transformToArray2D().visualizeView()
	}
	public func visualizeView(row row: Int) -> UIView {
		return self.transformToArray2D().visualizeView(row: row)
	}
	public func visualizeView(column col: Int) -> UIView {
		return self.transformToArray2D().visualizeView(column: col)
	}
}