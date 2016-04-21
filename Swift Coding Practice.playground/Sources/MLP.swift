import Foundation

public class MLP<T: SummableMultipliable> {
	public var x: [[T]]
	public var y: [[T]]
	public var sigmoidLayers: [HiddenLayer<T>]
	public var rbmLayers: [T]
	public var nLayers: Int
	public var settings: [String: Int] = [:]
	
	public init(settings: [String:Any]) {
		self.x = settings["input"] as! [[T]]
		self.y = settings["label"] as! [[T]]
		self.sigmoidLayers = []
		self.rbmLayers = []
		self.nLayers = Array<Int>(settings["hidden_layer_sizes"]! as! [Int]).count
		self.settings["log level"] =  1 // 0 : nothing, 1 : info, 2: warn
		var inputSize: Int
		var layerInput: [[T]] = []
		for i in 0..<self.nLayers+1 {
			let hidden_layer_sizes = Array<Int>(settings["hidden_layer_sizes"]! as! [Int])
			if(i == 0) {
				inputSize = settings["n_ins"] as! Int
				layerInput = self.x
			} else {
				inputSize = hidden_layer_sizes[i-1]
				self.sigmoidLayers.count-1
				layerInput = self.sigmoidLayers[self.sigmoidLayers.count-1].sampleHgivenV(layerInput)
			}
			var settingsForHL: [String: Any] = [
				"input" : layerInput,
				"n_in" : inputSize,
				"activation" : Math.sigmoid as (T) -> T
			]
			if i != self.nLayers {
				settingsForHL["n_out"] = hidden_layer_sizes[i]
				if let W = settings["w_array"] as? [[[T]]] {
					settingsForHL["W"] = W[i]
					if let b = settings["b_array"] as? [[T]] {
						settingsForHL["b"] = b[i]
					}
				}
			} else {
				settingsForHL["n_out"] = settings["n_outs"]
			}
			
			let sigmoidLayer: HiddenLayer<T> = HiddenLayer(settings: settingsForHL)
			self.sigmoidLayers.append(sigmoidLayer)
		}
	}
	public func train(settings: [String: Any]) {
		var lr:T = T() is Double ? 0.6 as! T : 0.6.toInt() as! T
		var epochs:T = T() is Double ? 1000.0 as! T : 1000 as! T // default
		if let lrValue = settings["lr"] {
			lr = lrValue as! T
		}
		if let eValue = settings["epochs"] {
			epochs = eValue as! T
		}
		var currentProgress:T = Math.one()
		for epoch in 0..<epochs.toInt() {
			
			// Feed Forward
			
			var layerInput:[[[T]]] = []
			layerInput.append(self.x)
			for i in 0..<self.nLayers+1 {
				layerInput.append(self.sigmoidLayers[i].output(layerInput[i]))
			}
			let output = layerInput[self.nLayers+1]
			// Back Propagation
			var delta:[[[T]]] = Array(count: self.nLayers + 1, repeatedValue: Math<T>.zeroMat(1, col: 1))//Array<Int>(arrayLiteral: self.nLayers + 1)
			delta[self.nLayers] = Math.mulMatElementWise(Math.minusMat(self.y, mat2: output), mat2: Math.activateMat(self.sigmoidLayers[self.nLayers].linearOutput(layerInput[self.nLayers]), activation: Math.dSigmoid))
			
			/*
			self.nLayers = 3 (3 hidden layers)
			delta[3] : ouput layer
			delta[2] : 3rd hidden layer, delta[0] : 1st hidden layer
			*/
			for i in (0..<self.nLayers).reverse() {
				delta[i] = Math.mulMatElementWise(self.sigmoidLayers[i+1].backPropagate(delta[i+1]), mat2: Math.activateMat(self.sigmoidLayers[i].linearOutput(layerInput[i]), activation: Math.dSigmoid))
			}
			// Update Weight, Bias
			for i in 0..<self.nLayers+1 {
				let deltaW = Math.activateMat(Math.mulMat(Math.transpose(layerInput[i]),mat2: delta[i])){
					x in
					let count = T() is Double ? self.x.count.toDouble() as! T : self.x.count as! T
					return Math.one() * x / count
				}
				let deltaB = Math.meanMatAxis(delta[i],axis: 0)
				self.sigmoidLayers[i].W = Math.addMat(self.sigmoidLayers[i].W,mat2: deltaW)
				self.sigmoidLayers[i].b = Math.addVec(self.sigmoidLayers[i].b,vec2: deltaB)
			}
			
			if(self.settings["log level"] > 0) {
				let iT = T() is Double ? epoch.toDouble() as! T : epoch as! T
				let hu = T() is Double ? Double(100) as! T : 100 as! T
				let eight = T() is Double ? Double(8) as! T : 8 as! T
				let progress = (Math.one() * iT / epochs) * hu
				if(progress > currentProgress) {
					print("MLP: \(progress.toInt())% Completed.")
					currentProgress += eight
				}
			}
			
		}
		if(self.settings["log level"] > 0) {
			print("MLP Final Cross Entropy : ",self.getReconstructionCrossEntropy())
		}
	}
	public func getReconstructionCrossEntropy() -> T {
		let reconstructedOutput = self.predict(self.x)
		let a = Math.activateTwoMat(self.y, mat2: reconstructedOutput){(x, y) in
			if T() is Double {
				return (x.toDouble() * log(y.toDouble())) as! T
			}
			return (x.toDouble() * log(y.toDouble())).toInt() as! T
		}
		
		let b = Math.activateTwoMat(self.y, mat2: reconstructedOutput){(x, y) in
			if T() is Double {
				return ((Math.one() - x).toDouble() * log((Math.one() - y).toDouble())) as! T
			}
			return ((Math.one() - x).toDouble() * log((Math.one() - y).toDouble())).toInt as! T
		}
		let crossEntropy = -Math.meanVec(Math.sumMatAxis(Math.addMat(a,mat2: b),axis: 1))
		return crossEntropy
	}
	public func predict(x: [[T]]) -> [[T]] {
		var output = x
		for i in 0..<self.nLayers+1 {
			output = self.sigmoidLayers[i].output(output)
		}
		return output
	}
	public func set(property: String, value: Int) {
		self.settings[property] = value
	}
}

