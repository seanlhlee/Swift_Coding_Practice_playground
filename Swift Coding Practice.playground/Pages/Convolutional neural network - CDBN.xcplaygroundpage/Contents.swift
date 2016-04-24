/*:
[Previous](@previous)
****
# 卷積神經網絡

卷積神經網絡（Convolutional Neural Network, CNN）是一種前饋神經網絡，它的人工神經元可以響應一部分覆蓋範圍內的周圍單元，[1]對於大型圖像處理有出色表現。

卷積神經網絡由一個或多個卷積層和頂端的全連通層（對應經典的神經網絡）組成，同時也包括關聯權重和池化層（pooling layer）。這一結構使得卷積神經網絡能夠利用輸入數據的二維結構。與其他深度學習結構相比，卷積神經網絡在圖像和語音識別方面能夠給出更優的結果。這一模型也可以使用反向傳播算法進行訓練。相比較其他深度、前饋神經網絡，卷積神經網絡需要估計的參數更少，使之成為一種頗具吸引力的深度學習結構。
*/

import Foundation

public class CDBN<T: SummableMultipliable>: DBN<T> {
	public override init(settings: [String: Any]) {
		super.init(settings: settings)
		let hidden_layer_sizes = Array<Int>(settings["hidden_layer_sizes"]! as! [Int])
		
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
			
			let rbmLayer = i==0 ?
				CRBM<T>(settings: [
				"input" : layerInput,
				"n_visible" : inputSize,
				"n_hidden" : num
				]) :
				RBM<T>(settings: [
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
}

var x = [[0.4, 0.5, 0.5, 0.0,  0.0,  0.0],
         [0.5, 0.3,  0.5, 0.0,  0.0,  0.0],
         [0.4, 0.5, 0.5, 0.0,  0.0,  0.0],
         [0.0,  0.0,  0.5, 0.3, 0.5, 0.0],
         [0.0,  0.0,  0.5, 0.4, 0.5, 0.0],
         [0.0,  0.0,  0.5, 0.5, 0.5, 0.0]]

var y: [[Double]] = [[1, 0],
         [1, 0],
         [1, 0],
         [0, 1],
         [0, 1],
         [0, 1]]

var cdbn = CDBN<Double>(settings: [
	"input" : x,
	"label" : y,
	"n_ins" : 6,
	"n_outs" : 2,
	"hidden_layer_sizes" : [10,12,11,8,6,4]
]);

for i in 0..<6 {
	print("ith layer W : ",cdbn.sigmoidLayers[i].W)
}

cdbn.set("log level",value: 1)
var pretrain_lr = 0.8, pretrain_epochs = 2000.0, k = 1.0, finetune_lr = 0.84, finetune_epochs = 10000.0

// Pre-Training using using RBM, CRBM.
cdbn.pretrain([
	"lr" : pretrain_lr,
	"k" : k,
	"epochs" : pretrain_epochs
])

// Fine-Tuning dbn using mlp backpropagation.
cdbn.finetune([
	"lr" : finetune_lr,
	"epochs" : finetune_epochs
])

let a = [[0.5, 0.5, 0.0, 0.0, 0.0, 0.0],
     [0.0, 0.0, 0.0, 0.5, 0.5, 0.0],
     [0.1, 0.2, 0.4, 0.4, 0.3, 0.6]]

print(cdbn.predict(a))

/*:
****
[Next](@next)
*/
