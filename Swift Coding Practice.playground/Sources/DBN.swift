import Foundation

public class DBN<T: SummableMultipliable> {
	public var x: [[T]]
	public var y: [[T]]
	public var sigmoidLayers: [HiddenLayer<T>]
	public var rbmLayers: [RBM<T>]
	public var nLayers: Int
	public var hiddenLayerSizes: [Int]
	public var nIns: Int
	public var nOuts: Int
	public var settings: [String: Int] = [:]
	public var outputLayer: HiddenLayer<T>
	
	public init(settings: [String: Any]) {
		let hidden_layer_sizes = Array<Int>(settings["hidden_layer_sizes"]! as! [Int])
		self.x = settings["input"] as! [[T]]
		self.y = settings["label"] as! [[T]]
		self.sigmoidLayers = []
		self.rbmLayers = []
		self.nLayers = hidden_layer_sizes.count
		self.hiddenLayerSizes = hidden_layer_sizes
		self.nIns = settings["n_ins"] as! Int
		self.nOuts = settings["n_outs"] as! Int
		self.settings["log level"] =  1 // 0 : nothing, 1 : info, 2: warn
		
		// Constructing Deep Neural Network
		var inputSize: Int
		var layerInput: [[T]] = []
		for i in 0..<self.nLayers {
			let num = hidden_layer_sizes[i]
			if(i == 0) {
				inputSize = settings["n_ins"] as! Int
				layerInput = self.x
			} else {
				inputSize = hidden_layer_sizes[i-1]
				self.sigmoidLayers.count-1
				layerInput = self.sigmoidLayers.last!.sampleHgivenV(layerInput)
			}
			let sigmoidLayer = HiddenLayer<T>(settings: [
				"input" : layerInput,
				"n_in" : inputSize,
				"n_out" : num,
				"activation" : Math.sigmoid  as (T) -> T
				])
			self.sigmoidLayers.append(sigmoidLayer)
			
			let rbmLayer = RBM<T>(settings: [
				"input" : layerInput,
				"n_visible" : inputSize,
				"n_hidden" : num
				])
			self.rbmLayers.append(rbmLayer)
		}
		self.outputLayer = HiddenLayer<T>(settings: [
			"input" : self.sigmoidLayers.last!.sampleHgivenV(layerInput),
			"n_in" : hidden_layer_sizes.last!,
			"n_out" : settings["n_outs"],
			"activation" : Math.sigmoid   as (T) -> T
			])
	}
	public func pretrain(settings: [String: Any]) {
		var lr:T = T() is Double ? 0.6 as! T : 0.6.toInt() as! T
		var k:T = Math.one()
		var epochs:T = T() is Double ? 2000.0 as! T : 2000 as! T // default
		if let lrValue = settings["lr"] {
			lr = lrValue as! T
		}
		if let kValue = settings["k"] {
			k = kValue as! T
		}
		if let eValue = settings["epochs"] {
			epochs = eValue as! T
		}
		
		var layerInput: [[T]] = []
		var rbm: RBM<T>
		for i in 0..<self.nLayers {
			if (i==0) {
				layerInput = self.x
			} else {
				layerInput = self.sigmoidLayers[i-1].sampleHgivenV(layerInput)
			}
			rbm = self.rbmLayers[i]
			rbm.set("log level",value: 0)
			rbm.train([
				"lr" : lr,
				"k" : k,
				"input" : layerInput,
				"epochs" : epochs
				])
			
			if(self.settings["log level"] > 0) {
				print("DBN RBM \(i)th Layer Final Cross Entropy: \(rbm.getReconstructionCrossEntropy())")
				print("DBN RBM \(i)th Layer Pre-Training Completed.")
			}
			
			// Synchronization between RBM and sigmoid Layer
			self.sigmoidLayers[i].W = rbm.W
			self.sigmoidLayers[i].b = rbm.hbias
		}
		if(self.settings["log level"] > 0) {
			print("DBN Pre-Training Completed.")
		}
	}
	public func finetune(settings: [String: Any]) {
		var lr:T = T() is Double ? 0.2 as! T : 0.2.toInt() as! T
		var epochs:T = T() is Double ? 1000.0 as! T : 1000 as! T // default
		if let lrValue = settings["lr"] {
			lr = lrValue as! T
		}
		if let eValue = settings["epochs"] {
			epochs = eValue as! T
		}
		
		//Fine-Tuning Using MLP (Back Propagation)
		var pretrainedWArray: [[[T]]] = []
		var pretrainedBArray:[[T]] = [] // HiddenLayer W,b values already pretrained by RBM.
		for i in 0..<self.nLayers {
			pretrainedWArray.append(self.sigmoidLayers[i].W)
			pretrainedBArray.append(self.sigmoidLayers[i].b)
		}
		// W,b of Final Output Layer are not involved in pretrainedWArray, pretrainedBArray so they will be treated as undefined at MLP Constructor.
		let mlp = MLP<T>(settings: [
			"input" : self.x,
			"label" : self.y,
			"n_ins" : self.nIns,
			"n_outs" : self.nOuts,
			"hidden_layer_sizes" : self.hiddenLayerSizes,
			"w_array" : pretrainedWArray,
			"b_array" : pretrainedBArray
			])
		mlp.set("log level",value: self.settings["log level"]!)
		mlp.train([
			"lr" : lr,
			"epochs" : epochs
			])
		for i in 0..<self.nLayers {
			self.sigmoidLayers[i].W = mlp.sigmoidLayers[i].W
			self.sigmoidLayers[i].b = mlp.sigmoidLayers[i].b
		}
		self.outputLayer.W = mlp.sigmoidLayers[self.nLayers].W
		self.outputLayer.b = mlp.sigmoidLayers[self.nLayers].b
		
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
		var layerInput = x
		for i in 0..<self.nLayers {
			layerInput = self.sigmoidLayers[i].output(layerInput)
		}
		let output = self.outputLayer.output(layerInput)
		return output
	}
	
	public func set(property: String, value: Int) {
		self.settings[property] = value
	}
}