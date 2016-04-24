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