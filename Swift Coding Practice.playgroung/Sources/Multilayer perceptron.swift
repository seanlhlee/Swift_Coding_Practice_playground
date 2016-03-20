import Foundation
// calculate a random number where:  a <= rand < b
public func rand(a: Int, b: Int) -> Int? {
	let range = a..<b
	return range.rand()
}
// Make a matrix (we could use NumPy to speed this up)
public func makeMatrix(I I: Int, J: Int, fill: Double = 0.0) -> [[Double]] {
	let array = Array(count: J, repeatedValue: fill)
	return Array(count: I, repeatedValue: array)
}
// our sigmoid function, tanh is a little nicer than the standard 1/(1+e^-x)
public func sigmoid(x: Double) -> Double {
	return tanh(x)
}
// derivative of our sigmoid function, in terms of the output (i.e. y)
public func dsigmoid(y: Double) -> Double {
	return 1.0 - y * y
}

public class NeuralNet {
	// number of input, hidden, and output nodes
	var ni: Int
	var nh: Int
	var no: Int
	var ai: [Double]
	var ah: [Double]
	var ao: [Double]
	var wi: [[Double]]
	var wo: [[Double]]
	var ci: [[Double]]
	var co: [[Double]]
	
	public init(ni: Int, nh: Int, no: Int) {
		self.ni = ni + 1	// +1 for bias node
		self.nh = nh
		self.no = no
		// activations for nodes
		self.ai = Array(count: self.ni, repeatedValue: 1.0)
		self.ah = Array(count: self.nh, repeatedValue: 1.0)
		self.ao = Array(count: self.no, repeatedValue: 1.0)
		// create weights
		self.wi = makeMatrix(I: self.ni, J: self.nh)
		self.wo = makeMatrix(I: self.nh, J: self.no)
		// set them to random vaules
		for i in 0..<self.ni {
			for j in 0..<self.nh {
				wi[i][j] = (rand(0, b: 4)! - 2).toDouble() * 0.1
			}
		}
		for j in 0..<self.nh {
			for k in 0..<self.no {
				wo[j][k] = (rand(0, b: 4)! - 2).toDouble()
			}
		}
		// last change in weights for momentum
		self.ci = makeMatrix(I: self.ni, J: self.nh)
		self.co = makeMatrix(I: self.nh, J: self.no)
	}
	
	// update() : 計算網路的輸出的函數
	public func update(inputs: [Double]) -> [Double] {
		// input activations : 設定輸入值
		for i in 0..<ni - 1 {
			ai[i] = inputs[i]
		}
		// hidden activations : 計算隱藏層輸出值 ah[j]
		for j in 0..<nh {
			var sum = 0.0
			for i in 0..<ni {
				sum += ai[i] * wi[i][j]
				ah[j] = sigmoid(sum)
			}
		}
		// output activations : 計算輸出層輸出值 ao[k]
		for k in 0..<no  {
			var sum = 0.0
			for j in 0..<nh {
				sum += ah[j] * wo[j][k];
				ao[k] = sigmoid(sum)
			}
		}
		return ao	// 傳回輸出層輸出值 ao
	}
	
	// backPropagate()：反傳遞學習的函數 (重要)
	public func backPropagate(targets: [Double], rate: Double, moment: Double) -> Double {
		// calculate error terms for output : 計算輸出層誤差
		var output_deltas = Array(count: no, repeatedValue: 0.0)
		for k in 0..<no {
			let error = targets[k] - ao[k]
			output_deltas[k] = dsigmoid(ao[k]) * error
		}
		// calculate error terms for hidden : 計算隱藏層誤差
		var hidden_deltas = Array(count: nh, repeatedValue: 0.0)
		for j in 0..<nh {
			var error = 0.0
			for k in 0..<no {
				// 注意、在此輸出層誤差 output_deltas 會反傳遞到隱藏層，因此才稱為反傳遞演算法。
				error = error + output_deltas[k] * wo[j][k]
			}
			hidden_deltas[j] = dsigmoid(ah[j]) * error
		}
		
		// update output weights : 更新輸出層權重
		for j in 0..<nh {
			for k in 0..<no {
				let change = output_deltas[k] * ah[j]
				wo[j][k] += rate * change + moment * co[j][k]
				co[j][k] = change
				// print N*change, M*this.co[j][k]
			}
		}
		// update input weights : 更新輸入層權重
		for i in 0..<ni {
			for j in 0..<nh {
				let change = hidden_deltas[j] * ai[i]
				wi[i][j] += rate * change + moment * ci[i][j]
				ci[i][j] = change
			}
		}
		
		// calculate error : 計算輸出層誤差總合
		var error = 0.0
		for k in 0..<targets.count {
			error += 0.5 * pow(targets[k] - ao[k], 2)
		}
		return error
	}
	// test() : 對真值表 (訓練樣本) 中的每個輸入都印出「網路輸出」與「期望輸出」，以便觀察學習結果是否都正確。
	public func test(patterns: [[[Double]]]) {
		for p in patterns {
			let inputs = p[0]
			let outputs = p[1]
			let predicts = update(inputs)
			var strs = [String]()
			for predict in predicts {
				strs.append(predict.format("-0.0"))
			}
			print("\(inputs) -> \(strs), \(outputs))")
		}
	}
	
	// train(): 主要學習函數，反覆呼叫反傳遞算法
	// 參數：rate: learning rate (學習速率), moment: momentum factor (動量常數)
	public func train(patterns: [[[Double]]], iterations: Int = 1000, rate: Double = 0.5, moment: Double = 0.1) {
		for i in 0..<iterations {
			var error = 0.0
			for p in patterns {
				let inputs = p[0]
				let targets = p[1]
				update(inputs)
				error += backPropagate(targets, rate: rate, moment: moment)
				if i % 100 == 0 {
					print("\(i): error   \(error)")
				}
			}
		}
	}
}

extension NeuralNet {
	public func outputCharacter(input: [Double]) -> Character {
		let bits = update(input)
		var bitsStr = [String]()
		for bit in bits {
			let element = abs(bit).format("-0.0")
			bitsStr.append(element)
		}
		let output = bitsStr.map{ $0 == "1" ? 1 : 0}
		var sum = 0
		for i in 0..<output.count {
			sum += output[output.count - 1 - i] * Int(pow(2.0, i.toDouble()))
		}
		return sum.hexRep().characters.last!
	}
}
