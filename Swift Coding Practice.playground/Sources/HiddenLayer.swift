import Foundation

public class HiddenLayer<T: SummableMultipliable> {
	public var settings: [String: Int] = [:]
	public var W: [[T]]
	public var input: [[T]]?
	public var b: [T]
	public var activation: (T) -> T
	
	public init(settings: [String:Any]) {
		if let i = settings["input"] {
			self.input = i as? [[T]]
		}
		if let wValue = settings["W"] {
			self.W = wValue  as! [[T]]
		} else {
			let n_in = settings["n_in"]! as! Int
			let n_out = settings["n_out"] as! Int
			let a = T() is Double ? 1.0 / n_in.toDouble() as! T : Math.one()
			let W = Math.randMat(n_in,col: n_out,lower: -a,upper: a)
			self.W = W
		}
		if let bValue = settings["b"] {
			self.b = bValue as! [T]
		} else {
			let b: [T] = Math.zeroVec(settings["n_out"] as! Int)
			self.b = b
		}
		if let act = settings["activation"] {
			self.activation = act as! (T) -> T
		} else {
			self.activation = Math.sigmoid
		}
	}
	
	
	public func output(input: [[T]]?) -> [[T]] {
		guard let i = input else { fatalError( "No BackPropagation Input." ) }
		self.input = i
		let linearOutput = Math.addMatVec(Math.mulMat(self.input!,mat2: self.W),vec: self.b)
		return Math.activateMat(linearOutput,activation: self.activation)
	}
	
	public func linearOutput(input: [[T]]?) -> [[T]] { // returns the value before activation.
		guard let i = input else { fatalError( "No BackPropagation Input." ) }
		self.input = i
		let linearOutput = Math.addMatVec(Math.mulMat(self.input!,mat2: self.W),vec: self.b)
		return linearOutput
	}
	
	public func backPropagate(input: [[T]]?) -> [[T]]{ // example+num * n_out matrix
		guard let i = input else { fatalError( "No BackPropagation Input." ) }
		self.input = i
		let linearOutput = Math.mulMat(self.input!, mat2: Math.transpose(self.W))
		return linearOutput
	}
	
	public func sampleHgivenV(input: [[T]]?) -> [[T]]{
		guard let i = input else { fatalError( "No BackPropagation Input." ) }
		self.input = i
		let hMean = self.output(self.input)
		let hSample = Math.probToBinaryMat(hMean)
		return hSample
	}
	
	
}

