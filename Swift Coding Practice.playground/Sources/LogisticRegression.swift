import Foundation

public class LogisticRegression<T: SummableMultipliable> {
	public var x: [[T]]
	public var y: [[T]]
	public var W: [[T]]
	public var b: [T]
	public var settings: [String: Int] = [:]
	
	public init(settings: [String:Any]) {
		self.x = settings["input"] as! [[T]]
		self.y = settings["label"] as! [[T]]
		self.W = Math.zeroMat(settings["n_in"] as! Int,col: settings["n_out"] as! Int)
		self.b = Math.zeroVec(settings["n_out"] as! Int)
		self.settings = ["log level" : 1] // 0 : nothing, 1 : info, 2: warn
	}
	public func train(settings: [String: Any]) {
		var lr:T = T() is Double ? 0.1 as! T : 0.1.toInt() as! T
		var epochs:T = T() is Double ? 200.0 as! T : 200 as! T // default
		
		if let i = settings["input"] {
			self.x = i as! [[T]]
		}
		if let lrValue = settings["lr"] {
			lr = lrValue as! T
		}
		if let eValue = settings["epochs"] {
			epochs = eValue as! T
		}
		var currentProgress:T = Math.one()
		for i in 0..<epochs.toInt() {
			let probYgivenX = Math.softmaxMat(Math.addMatVec(Math.mulMat(self.x,mat2: self.W),vec: self.b))
			let deltaY = Math.minusMat(self.y,mat2: probYgivenX)
			
			let deltaW = Math.mulMat(Math.transpose(self.x),mat2: deltaY)
			let deltaB = Math.meanMatAxis(deltaY,axis: 0)
			
			self.W = Math.addMat(self.W,mat2: Math.mulMatScalar(deltaW,scalar: lr))
			self.b = Math.addVec(self.b,vec2: Math.mulVecScalar(deltaB,scalar: lr))
			if(self.settings["log level"] > 0) {
				let iT = T() is Double ? i.toDouble() as! T : i as! T
				let hu = T() is Double ? Double(100) as! T : 100 as! T
				let progress = (Math.one() * iT / epochs) * hu
				if(progress > currentProgress) {
					print("LogisticRegression: \(progress.toInt())% Completed.")
					currentProgress += Math.one()
				}
			}
		}
		if(self.settings["log level"] > 0) {
			print("LogisticRegression Final Cross Entropy : \(self.getReconstructionCrossEntropy())")
		}
	}
	
	public func getReconstructionCrossEntropy() -> T {
		let probYgivenX = Math.softmaxMat(Math.addMatVec(Math.mulMat(self.x,mat2: self.W),vec: self.b))
		let a = Math.mulMatElementWise(self.y, mat2: Math.activateMat(probYgivenX){ x in
			if T() is Double {
				return log(x.toDouble()) as! T
			}
			return log(x.toDouble()).toInt() as! T
			})
		let mat2: [[T]] = Math.activateMat(Math.mulMatScalar(Math.addMatScalar(probYgivenX,scalar: -Math.one()),scalar: -Math.one())){ x in
			if T() is Double {
				return log(x.toDouble()) as! T
			}
			return log(x.toDouble()).toInt() as! T
		}
		let b = Math.mulMatElementWise(Math.mulMatScalar(Math.addMatScalar(self.y,scalar: -Math.one()),scalar: -Math.one()),
		                               mat2: mat2)
		let crossEntropy = -Math.meanVec(Math.sumMatAxis(Math.addMat(a,mat2: b),axis: 1))
		return crossEntropy
	}
	
	public func predict(x: [[T]]) -> [[T]] {
		return Math.softmaxMat(Math.addMatVec(Math.mulMat(x,mat2: self.W),vec: self.b))
	}
	
	public func set(property: String, value: Int) {
		self.settings[property] = value
	}
}