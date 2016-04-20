
import Foundation

public class RBM<T: SummableMultipliable> {
	public var nVisible: Int
	public var nHidden: Int
	public var settings: [String: Int] = [:]
	public var W: [[T]]
	public var hbias: [T]
	public var vbias: [T]
	public var input: [[T]]
	public init(settings: [String: Any]) {
		self.nVisible = settings["n_visible"] as! Int
		self.nHidden = settings["n_hidden"] as! Int
		self.settings["log level"] =  1 // 0 : nothing, 1 : info, 2: warn
		if let wValue = settings["W"] {
			self.W = wValue  as! [[T]]
		} else {
			let a = T() is Double ? 1.0 / self.nVisible.toDouble() as! T : Math.one()
			let W = Math.randMat(self.nVisible,col: self.nHidden,lower: -a,upper: a)
			self.W = W
			//			self.settings["W"] = W
		}
		if let hValue = settings["hbias"] {
			self.hbias = hValue as! [T]
		} else {
			let hbias: [T] = Math.zeroVec(self.nHidden)
			self.hbias = hbias
			//			self.settings["hbias"] = hbias
		}
		if let vValue = settings["vbias"] {
			self.vbias = vValue as! [T]
		} else {
			let vbias: [T] = Math.zeroVec(self.nVisible)
			self.vbias = vbias
			//			self.settings["vbias"] = vbias
		}
		self.input = settings["input"]! as! [[T]]
	}
	public func train(settings: [String: Any]) {
		var lr:T = T() is Double ? 0.8 as! T : 0.8.toInt() as! T
		var k:T = Math.one()
		var epochs:T = T() is Double ? 1500.0 as! T : 1500 as! T // default
		if let input = settings["input"] {
			self.input = input as! [[T]]
		}
		if let lrValue = settings["lr"] {
			lr = lrValue as! T
		}
		if let kValue = settings["k"] {
			k = kValue as! T
		}
		if let eValue = settings["epochs"] {
			epochs = eValue as! T
		}
		var currentProgress:T = Math.one()
		for i in 0..<epochs.toInt() {
			/* CD - k . Contrastive Divergence */
			var ph = self.sampleHgivenV(self.input)
			var phMean = ph[0], phSample = ph[1]
			let chainStart = phSample
			var nvMeans = [[T]](), nvSamples = [[T]](), nhMeans = [[T]](), nhSamples = [[T]]()
			
			for j in 0..<k.toInt() {
				if (j==0) {
					var gibbsVH = self.gibbsHVH(chainStart)
					nvMeans		= gibbsVH[0]
					nvSamples	= gibbsVH[1]
					nhMeans		= gibbsVH[2]
					nhSamples	= gibbsVH[3]
				} else {
					var gibbsVH = self.gibbsHVH(nhSamples)
					nvMeans		= gibbsVH[0]
					nvSamples	= gibbsVH[1]
					nhMeans		= gibbsVH[2]
					nhSamples	= gibbsVH[3]
				}
			}
			let count = T() is Double ? self.input.count.toDouble() as! T : self.input.count as! T
			let deltaW = Math.mulMatScalar(Math.minusMat(Math.mulMat(Math.transpose(self.input),mat2: phMean), mat2: Math.mulMat(Math.transpose(nvSamples),mat2: nhMeans)),scalar: Math.one() / count)
			let deltaVbias = Math.meanMatAxis(Math.minusMat(self.input,mat2: nvSamples),axis: 0)
			let deltaHbias = Math.meanMatAxis(Math.minusMat(phSample,mat2: nhMeans),axis: 0)
			
			self.W = Math.addMat(self.W, mat2: Math.mulMatScalar(deltaW,scalar: lr))
			self.vbias = Math.addVec(self.vbias, vec2: Math.mulVecScalar(deltaVbias,scalar: lr))
			self.hbias = Math.addVec(self.hbias, vec2: Math.mulVecScalar(deltaHbias,scalar: lr))
			if(self.settings["log level"] > 0) {
				let iT = T() is Double ? i.toDouble() as! T : i as! T
				let hu = T() is Double ? Double(100) as! T : 100 as! T
				let eight = T() is Double ? Double(8) as! T : 8 as! T
				let progress = (Math.one() * iT / epochs) * hu
				if(progress > currentProgress) {
					print("RBM: \(progress.toInt)% Completed.")
					currentProgress += eight
				}
			}
		}
		if(self.settings["log level"] > 0) {
			print("RBM Final Cross Entropy : ",self.getReconstructionCrossEntropy())
		}
	}
	
	
	public func propup(v: [[T]]) -> [[T]] {
		let preSigmoidActivation = Math.addMatVec(Math.mulMat(v,mat2: self.W),vec: self.hbias)
		return Math.activateMat(preSigmoidActivation, activation: Math.sigmoid)
	}
	
	public func propdown(h: [[T]]) -> [[T]] {
		let preSigmoidActivation = Math.addMatVec(Math.mulMat(h,mat2: Math.transpose(self.W)),vec: self.vbias)
		return Math.activateMat(preSigmoidActivation, activation: Math.sigmoid)
	}
	public func sampleHgivenV(v0_sample: [[T]]) -> [[[T]]] {
		let h1_mean = self.propup(v0_sample)
		let h1_sample = Math.probToBinaryMat(h1_mean)
		return [h1_mean,h1_sample]
	}
	
	public func sampleVgivenH(h0_sample: [[T]]) -> [[[T]]] {
		let v1_mean = self.propdown(h0_sample)
		let v1_sample = Math.probToBinaryMat(v1_mean)
		return [v1_mean,v1_sample]
	}
	public func gibbsHVH(h0_sample: [[T]]) -> [[[T]]] {
		var v1 = self.sampleVgivenH(h0_sample)
		var h1 = self.sampleHgivenV(v1[1])
		return [v1[0],v1[1],h1[0],h1[1]]
	}
	public func reconstruct(v: [[T]]) -> [[T]] {
		let h = Math.activateMat(Math.addMatVec(Math.mulMat(v,mat2: self.W),vec: self.hbias), activation: Math.sigmoid)
		return Math.activateMat(Math.addMatVec(Math.mulMat(h, mat2: Math.transpose(self.W)),vec: self.vbias), activation: Math.sigmoid)
	}
	public func getReconstructionCrossEntropy() -> T{
		let reconstructedV = reconstruct(self.input)
		let a = Math.activateTwoMat(self.input,mat2: reconstructedV){(x, y) in
			if T() is Double {
				return (x.toDouble() * log(y.toDouble())) as! T
			}
			return (x.toDouble() * log(y.toDouble())).toInt() as! T
		}
		let b = Math.activateTwoMat(self.input,mat2: reconstructedV){(x, y) in
			if T() is Double {
				return ((Math.one() - x).toDouble() * log((Math.one() - y).toDouble())) as! T
			}
			return ((Math.one() - x).toDouble() * log((Math.one() - y).toDouble())).toInt as! T
		}
		let crossEntropy = -Math.meanVec(Math.sumMatAxis(Math.addMat(a,mat2: b),axis: 1))
		return crossEntropy
	}
	public func set(property: String, value: Int) {
		self.settings[property] = value
	}
}
