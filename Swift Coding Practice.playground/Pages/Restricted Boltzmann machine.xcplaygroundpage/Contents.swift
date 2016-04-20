/*:

# 深度學習

深度學習（英語：deep learning）是機器學習的一個分支，它基於試圖使用包含複雜結構或由多重非線性變換構成的多個處理層對資料進行高層抽象的一系列演算法。

深度學習是機器學習中表征學習方法的一類。一個觀測值（例如一幅圖像）可以使用多種方式來表示，如每個像素強度值的向量，或者更抽象地表示成一系列邊、特定形狀的區域等。而使用某些特定的表示方法更加容易地從例項中學習任務（例如，人臉識別或面部表情識別）。深度學習的好處之一是將用非監督式或半監督式的特徵學習和分層特徵提取的高效演算法來替代手工取得特徵。

表征學習的目標是尋求更好的表示方法並建立更好的模型來從大規模未標記資料中學習這些表示方法。一些表達方式的靈感來自於神經科學的進步，並鬆散地建立在神經系統中的資訊處理和通信模式的理解基礎上，如神經編碼，試圖定義刺激和神經元的反應之間的關係以及大腦中的神經元的電活動之間的關係。

至今已有多種深度學習框架，如深度神經網路、卷積神經網路和深度信念網路和遞迴神經網路已被應用於電腦視覺、語音識別、自然語言處理、音訊識別與生物資訊學等領域並取得了極好的效果。

另外，深度學習已成為一個時髦術語，或者說是神經網路的品牌重塑。

![](1.png)

## 深度置信網路

深度置信網路（deep belief networks，DBN）是一種包含多層隱單元的機率生成模型，可被視為多層簡單學習模型組合而成的複合模型。

深度置信網路可以作為深度神經網路的預訓練部分，並為網路提供初始權重，再使用反向傳播或者其他判定演算法作為調優的手段。這在訓練資料較為缺乏時很有價值，因為不恰當的初始化權重會顯著影響最終模型的效能，而預訓練獲得的權重在權值空間中比隨機權重更接近最優的權重。這不僅提升了模型的效能，也加快了調優階段的收斂速度。

深度置信網路中的每一層都是典型的受限玻爾茲曼機（restricted Boltzmann machine，RBM），可以使用高效的無監督逐層訓練方法進行訓練。受限玻爾茲曼機是一種無向的基於能量的生成模型，包含一個輸入層和一個隱層。圖中對的邊僅在輸入層和隱層之間存在，而輸入層節點內部和隱層節點內部則不存在邊。單層RBM的訓練方法最初由傑弗里·辛頓在訓練「專家乘積」中提出，被稱為對比分歧（contrast divergence, CD）。對比分歧提供了一種對最大似然的近似，被理想地用於學習受限玻爾茲曼機的權重。當單層RBM被訓練完畢後，另一層RBM可被堆疊在已經訓練完成的RBM上，形成一個多層模型。每次堆疊時，原有的多層網路輸入層被初始化為訓練樣本，權重為先前訓練得到的權重，該網路的輸出作為新增RBM的輸入，新的RBM重複先前的單層訓練過程，整個過程可以持續進行，直到達到某個期望中的終止條件。

儘管對比分歧對最大似然的近似十分粗略（對比分歧並不在任何函式的梯度方向上），但經驗結果證實該方法是訓練深度結構的一種有效的方法。

![](2.png)
一個包含完全連線可見層和隱層的受限玻爾茲曼機（RBM）。注意到可見層單元和隱層單元內部彼此不相連。

參考資料:
[Reducing the Dimensionality of Data with Neural Networks]: http://www.cs.toronto.edu/~hinton/science.pdf ""
Hinton, G. E. and Salakhutdinov, R. R. [Reducing the Dimensionality of Data with Neural Networks] (PDF). Science. 2006, 313 (5786): 504–507.


*/

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
					print("RBM: \(progress.toInt())% Completed.")
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
var data: [[Double]] =
			[[1,1,1,0,0,0],
            [1,0,1,0,0,0],
            [1,1,1,0,0,0],
            [0,0,1,1,1,0],
            [0,0,1,1,0,0],
            [0,0,1,1,1,0]]

var pretrain_lr = 0.6, pretrain_epochs = 900, k = 1, finetune_lr = 0.6, finetune_epochs = 500;
let settings: [String: Any] = ["input" : data, "n_visible" : 6, "n_hidden" : 2]
var rbm = RBM<Double>(settings: settings)
rbm.set("log level", value: 1)
var trainingEpochs = 500.0
rbm.train(["lr": 0.6, "k": 1.0, "epochs": trainingEpochs])
var v: [[Double]] = [[1, 1, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0]]
print(rbm.reconstruct(v))
print(rbm.sampleHgivenV(v)[0])
