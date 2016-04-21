/*:
[Previous](@previous)
****
# 多層感知器
多層感知器（Multilayer Perceptron,縮寫MLP）是一種前向結構的人工神經網絡，映射一組輸入向量到一組輸出向量。MLP可以被看作是一個有向圖，由多個的節點層所組成，每一層都全連接到下一層。除了輸入節點，每個節點都是一個帶有非線性激活函數的神經元（或稱處理單元）。一種被稱為反向傳播算法的監督學習方法常被用來訓練MLP。 MLP是感知器的推廣，克服了感知器不能對線性不可分數據進行識別的弱點。

## 激活函數
若每個神經元的激活函數都是線性函數，那麼，任意層數的MLP都可被約簡成一個等價的單層感知器。

實際上，MLP本身可以使用任何形式的激活函數，譬如階梯函數或邏輯乙形函數（logistic sigmoid function），但為了使用反向傳播算法進行有效學習，激活函數必須限制為可微函數。由於具有良好可微性，很多乙形函數，尤其是雙曲正切函數（Hyperbolic tangent）及邏輯乙形函數，被採用為激活函數。

## 應用
常被MLP用來進行學習的反向傳播算法，在模式識別的領域中算是標準監督學習算法，並在計算神經學及並行分布式處理領域中，持續成為被研究的課題。MLP已被證明是一種通用的函數近似方法，可以被用來擬合複雜的函數，或解決分類問題。

MLP在80年代的時候曾是相當流行的機器學習方法，擁有廣泛的應用場景，譬如語音識別、圖像識別、機器翻譯等等，但自90年代以來，MLP遇到來自更為簡單的支持向量機的強勁競爭。近來，由於深層學習的成功，MLP又重新得到了關注。
*/

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



var x = [[0.4, 0.5, 0.5, 0.0,  0.0,  0.0],
         [0.5, 0.3,  0.5, 0.0,  0.0,  0.0],
         [0.4, 0.5, 0.5, 0.0,  0.0,  0.0],
         [0.0,  0.0,  0.5, 0.3, 0.5, 0.0],
         [0.0,  0.0,  0.5, 0.4, 0.5, 0.0],
         [0.0,  0.0,  0.5, 0.5, 0.5, 0.0]]
var y =  [[1.0, 0.0],
          [1.0, 0.0],
          [1.0, 0.0],
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0]]


var mlp = MLP<Double>(settings: [
	"input" : x,
	"label" : y,
	"n_ins" : 6,
	"n_outs" : 2,
	"hidden_layer_sizes" : [4,4,5]
])

mlp.set("log level",value: 1)

mlp.train([
	"lr" : 0.6,
	"epochs" : 20000.0
])

let a = [[0.5, 0.5, 0.0, 0.0, 0.0, 0.0],
     [0.0, 0.0, 0.0, 0.5, 0.5, 0.0],
     [0.5, 0.5, 0.5, 0.5, 0.5, 0.0]]

print(mlp.predict(a))

/*:
****
[Next](@next)
*/