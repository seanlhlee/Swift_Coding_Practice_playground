import Foundation

public struct HillClimbing3D {
	private var function3D: Function3D
	private var step = 0.1
	private var bestSolution: Point3D?

	public init(equation: (Point3D) -> Double, initial: Point3D, step: Double = 0.1) {
		self.function3D = Function3D(equation: equation, point: initial)
		self.step = step
		self.bestSolution = initial
	}
	public mutating func run() {
		var currentSolution: Point3D {
			get {
				return function3D.getPoint()
			}
			set {
				function3D.update(newValue)
			}
		}
		print("Initial solution energy: " + function3D.description)
		while true {
			let neighbor = function3D.neighbor(step)
			let neighbourEnergy = function3D.getEnergy(neighbor)
			let bestEnergy = function3D.getEnergy(bestSolution!)
			if (neighbourEnergy < bestEnergy) {
				currentSolution = neighbor
				bestSolution = neighbor
			} else {
				function3D.update(bestSolution!)
				print("Final solution energy: \(function3D.getEnergy(bestSolution!))")
				print("Best Solution: " + bestSolution!.description)
				break
			}
		}
	}
	public var description: String {
		return function3D.description + "current @\(function3D.getPoint().description)" + "best sol: \(bestSolution?.description)"
	}
}