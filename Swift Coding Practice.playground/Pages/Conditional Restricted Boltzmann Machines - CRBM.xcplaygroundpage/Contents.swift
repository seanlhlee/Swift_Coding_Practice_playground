/*:
[Previous](@previous)
****
# Conditional Restricted Boltzmann Machines
*/

import Foundation

public class CRBM<T: SummableMultipliable>: RBM<T> {
	public override init(settings: [String: Any]) {
		super.init(settings: settings)
	}
	
	public override func propdown(h: [[T]]) -> [[T]]  {
		let preSigmoidActivation = Math.addMatVec(Math.mulMat(h,mat2: Math.transpose(self.W)),vec: self.vbias)
		return preSigmoidActivation
	}

	public override func sampleVgivenH(h0_sample: [[T]]) -> [[[T]]] {
		
		let a_h = self.propdown(h0_sample)
		let a = Math.activateMat(a_h){x in
			if T() is Double {
				return Math.one() / (Math.one() - exp(-x.toDouble()) as! T)
			}
			return Math.one() / (1.0 - exp(-x.toDouble())).toInt() as! T
		}
		let b = Math.activateMat(a_h) {x in Math.one()/x }
		let v1_mean = Math.minusMat(a,mat2: b)
		let U = Math.randMat(Math<T>.shape(v1_mean)[0],col: Math<T>.shape(v1_mean)[1],lower: T(),upper: Math.one())
		let c = Math.activateMat(a_h){x in
			if T() is Double {
				return (Math.one() - exp(x.toDouble()) as! T)
			}
			return (1.0 - exp(x.toDouble())).toInt() as! T
		}

		let d = Math.activateMat(Math.mulMatElementWise(U,mat2: c)){x in Math.one() - x}
		let mat1 = Math.activateMat(d){x in
			return T() is Double ? log(x.toDouble()) as! T : log(x.toDouble()).toInt() as! T
		}
		let v1_sample = Math.activateTwoMat(mat1,mat2: a_h){
			(x,y) in
			let epsilon = T() is Double ? 1e-14 as! T : T()
			let yy = y == T() ? y + epsilon : y  // Javascript Float Precision Problem.. This is a limit of javascript.
			return x/yy
			}
		return [v1_mean,v1_sample]
	}
	public override func getReconstructionCrossEntropy() -> T {
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
	
	public override func reconstruct(v: [[T]]) -> [[T]] {
		let reconstructedV = self.sampleVgivenH(self.sampleHgivenV(v)[0])[0]
		return reconstructedV
	}
}


var data = [[0.4, 0.5, 0.5, 0.0,  0.0,  0.7],
            [0.5, 0.3,  0.5, 0.0,  1.0,  0.6],
            [0.4, 0.5, 0.5, 0.0,  1.0,  0.9],
            [0.0,  0.0,  0.0, 0.3, 0.5, 0.0],
            [0.0,  0.0,  0.0, 0.4, 0.5, 0.0],
            [0.0,  0.0,  0.0, 0.5, 0.5, 0.0]]


var crbm = CRBM<Double>(settings: [
	"input" : data,
	"n_visible" : 6,
	"n_hidden" : 5
])

crbm.set("log level",value: 1)

crbm.train([
	"lr" : 0.6,
	"k" : 1.0,
	"epochs" : 1500.0
])



var v = [[0.5, 0.5, 0.0, 0.0, 0.0, 0.0],
         [0.0, 0.0, 0.0, 0.5, 0.5, 0.0]]

print(crbm.reconstruct(v))
print(crbm.sampleHgivenV(v)[0])

/*:
****
[Next](@next)
*/