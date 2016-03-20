import Foundation

public struct Point3D {
	private var x: Double
	private var y: Double
	private var z: Double
	public var point: (x: Double, y: Double, z: Double) {
		get {
			return (x,y,z)
		}
		set {
			x = newValue.x
			y = newValue.y
			z = newValue.z
		}
	}
	public init(point: (x: Double, y: Double, z: Double)) {
		self.x = point.x
		self.y = point.y
		self.z = point.z
	}
	public init() {
		x = 0.0
		y = 0.0
		z = 0.0
	}
	public init(_ x: Double, _ y: Double, _ z: Double) {
		self.x = x
		self.y = y
		self.z = z
	}
	public var description: String {
		return "( \(x), \(y), \(z) )"
	}
}

public struct Function3D {
	private var f: (Point3D) -> Double
	private var p: Point3D
	private var energy: Double {
		return f(p)
	}
	public init(equation: (Point3D) -> Double, point: Point3D) {
		self.f = equation
		self.p = point
	}
	public mutating func update(newPoint: Point3D) {
		p = newPoint
	}
	public func getPoint() -> Point3D{
		return p
	}
	public func getEnergy(point: Point3D) -> Double {
		return f(point)
	}
	public func neighbor(step: Double) -> Point3D {
		var neighbors = [Point3D]()
		for i in -1...1 {
			for j in -1...1 {
				for k in -1...1 {
					let newPoint = Point3D(p.x + step * i.toDouble(), p.y + step * j.toDouble(), p.z + step * k.toDouble())
					if i != 0 && j != 0 && k != 0 { neighbors.append(newPoint) }
				}
			}
		}
		let deltas = neighbors.map{ getEnergy($0) - energy }
		for i in 0..<neighbors.count {
			if deltas[i] == deltas.minElement() {
				return neighbors[i]
			}
		}
		return p
	}
	public var description: String {
		return "f\(p.description) = \(energy)"
	}
	
}

public struct SimulatedAnnealing3D {
	private var function3D: Function3D
	private var temp: Double = 100.0
	private var coolingRate = 0.003
	private var step = 0.1
	private var bestSolution: Point3D?
	private var randomThreshold: Bool = true
	private var fixedThreshold = 0.5
	public init(equation: (Point3D) -> Double, initial: Point3D, temp: Double = 100.0, coolingRate: Double = 0.003, step: Double = 0.1, randomThreshold: Bool = true, fixedThreshold: Double = 0.5) {
		self.function3D = Function3D(equation: equation, point: initial)
//		self.initialSolution = initial
		self.temp = temp
		self.coolingRate = coolingRate
		self.step = step
		self.randomThreshold = randomThreshold
		self.fixedThreshold = fixedThreshold
		self.bestSolution = initial
	}
	public func acceptanceProbability(energy: Double, newEnergy: Double, temperature: Double) -> Double {
		if (newEnergy < energy) {
			return 1.0
		}
		return exp((energy - newEnergy).toDouble() / temperature)
	}
	public mutating func run() {
		var t = temp
		let coolingScale = 1 - coolingRate
		var currentSolution: Point3D {
			get {
				return function3D.p
			}
			set {
				function3D.update(newValue)
			}
		}
		print("Initial solution energy: " + function3D.description)
		while (t > 1) {
			let currentEnergy = function3D.getEnergy(currentSolution)
			let neighbor = function3D.neighbor(step)
			let neighbourEnergy = function3D.getEnergy(neighbor)
			let bestEnergy = function3D.getEnergy(bestSolution!)
			let threshold: Double = randomThreshold ? arc4random().toDouble() / UInt32.max.toDouble() : 0.5
			if (acceptanceProbability(currentEnergy, newEnergy: neighbourEnergy, temperature: t) > threshold) {
				currentSolution = neighbor
			}
			if (neighbourEnergy < bestEnergy) {
				bestSolution = neighbor
			}
			t *= coolingScale
		}
		function3D.update(bestSolution!)
		print("Final solution energy: \(function3D.getEnergy(bestSolution!))")
		print("Best Solution: " + bestSolution!.description)
	}
	public var description: String {
		return function3D.description + "current @\(function3D.p.description)" + "best sol: \(bestSolution?.description)"
	}
}



