/*:
[Previous](@previous)
****

# SWIFT程式設計練習題

## 演算法

### 求一元二次方程式 ax^2+bx+c=0 的根。

範例： findroot(1,-4,4) => 2

[參考]:http://zerojudge.tw/ShowProblem?problemid=a006
[參考]：http://zerojudge.tw/ShowProblem?problemid=a006
*/
import Foundation
func findroot(a: Int, b: Int, c: Int) -> String {
	let ac = b * b - 4 * a * c
	guard ac >= 0 else { return "本題無解" }
	let a1 = (-b.toDouble() + sqrt(ac.toDouble())) / 2.toDouble() / a.toDouble()
	let a2 = (-b.toDouble() - sqrt(ac.toDouble())) / 2.toDouble() / a.toDouble()
	let str = a1 == a2 ? "有一解為\(a1)" : "有兩解分別為x1 = \(a1), x2 = \(a2)"
	return str
}
findroot(1, b: -4, c: 4)
findroot(1, b: -5, c: 6)

let imax = Int.max.toDouble()
let imin = Int.min.toDouble()


/* 下面的方法很難收斂
func findRoot(a: Int, b: Int, c: Int) -> String {
	var lb = imin
	var rb = imax
	var mid = 0.0
	func f(x: Double) -> Double {
		return a.toDouble() * x * x + b.toDouble() * x + c.toDouble()
	}
	func sameSide(x: Double, y: Double, f: (Double) -> Double) -> Bool {
		let xp = f(x) > 0
		let yp = f(y) > 0
		return xp == yp
	}
	guard !(f(lb) > 0 && f(rb) > 0 && f(0.0) > f(lb) && f(0.0) > f(rb)) else { return "本題無解" }
	guard !(f(lb) < 0 && f(rb) < 0 && f(0.0) < f(lb) && f(0.0) < f(rb)) else { return "本題無解" }
	while f(lb) != 0 {
		if sameSide(lb, y: mid, f: f) {
			lb = mid
			mid = (lb + rb) / 2
		} else {
			let half = (mid - lb) / 2
			if f(lb + half) == 0 {
				lb += half
				break
			} else if sameSide(lb, y: lb + half, f: f) {
				lb += half
			} else {
				mid -= half
			}
		}
	}
	while f(rb) != 0 {
		if sameSide(rb, y: mid, f: f) {
			rb = mid
			mid = (lb + rb) / 2
		} else {
			let half = (rb - mid) / 2
			if f(rb - half) == 0 {
				rb -= half
				break
			} else if sameSide(rb, y: rb - half, f: f) {
				lb -= half
			} else {
				mid += half
			}
		}
	}
	return rb == lb ? "有一解為\(rb)" : "有兩解分別為x1 = \(lb), x2 = \(rb)"
}

findRoot(1, b: -4, c: 4)
findroot(1, b: -5, c: 6)
*/
/*:
### 請寫出 minimal 函數可以找出函數 f 的區域最低點。

範例： function f(x) { return x*x-4*x+4; } minimal(f) => x=2, f(2)=0
*/
func findMinMax(a: Int, b: Int, c: Int) -> (String, Double) {
	let str = a > 0 ? "最低點" : "最高點"
	return (str, -b.toDouble() / 2.toDouble() / a.toDouble())
}
findMinMax(1, b: -4, c: 4)
findMinMax(-1, b: 4, c: -4)
/*:
### 請寫出 maximal 函數可以找出函數 f 的區域最高點。

範例： function f(x) { return -1*(x*x-4*x+4); } maximal(f) => x=2, f(2)=0
*/
//
/*:
### 爬山演算法

	Algorithm HillClimbing(f,x)
		x = 隨意設定的一個解
		while (x有鄰居，x'比x更高)
			x = x';
		end
		return x;
	return
*/
import Foundation

func hillClimbing<T: IntegerArithmeticType>(f: (T) -> T, inout x: T, dx: T) -> (x: T, fx: T) {
//func hillClimbing<T: IntegerArithmeticType>(f: (T) -> T, inout x: T, dx: T) {
	while true {
		print("f(\(x)) = \(f(x))")
		if f(x + dx) >= f(x) {
			 x += dx
		} else if f(x - dx) >= f(x) {
			x -= dx
		} else {
			return (x, f(x))
		}
	}
}
func hillClimbing(f: (Double) -> Double, inout x: Double, dx: Double) -> (x: Double, fx: Double) {
	while true {		
		print("f(\(x.format("+.2"))) = \(f(x).format("+.4"))")
		if f(x + dx) >= f(x) {
			x += dx
		} else if f(x - dx) >= f(x) {
			x -= dx
		} else {
			return (x, f(x))
		}
	}
}
var f = {
	(x: Double) -> Double in
	-(x * x + 3 * x + 5)
}
var x:Double = 0.0, dx: Double = 0.01
//hillClimbing(f, x: &x, dx: dx)

let f1 = {
	(x: Double) -> Double in
	-(x * x - 4 * x + 4)
}
x = 0
//hillClimbing(f1, x: &x, dx: dx)

let f2 = {
	(x: Double) -> Double in
	-(x * x * x - 6 * x * x + 6 * x + 8)
}
x = 2
//hillClimbing(f2, x: &x, dx: dx)

let f3 = {
	(x: Double) -> Double in
	-abs(x * x - 4)
}
x = 0
//hillClimbing(f3, x: &x, dx: dx)

struct HillClimbing {
	var f: (Double) -> Double
	var sol: Double
	var step: Double

	var report: String {
		var solution = sol
		var neighbor: [Double] {
			var array = [Double]()
			for i in 0..<2 {
				let advance = i % 2 == 0 ? step : -step
				array.append(solution.advancedBy(advance))
			}
			return array
		}
		var height: Double {
			return f(solution)
		}
		while true {
			var solArray = [Double]()
			if f(neighbor[0]) >= height && f(neighbor[1]) >= height {
				solArray = [solution, solution]
				while true {
					if f(neighbor[0]) >= height {
						solution = neighbor[0]
					} else {
						solArray[0] = solution
						solution = solArray[1]
						break
					}
				}
				while true {
					if f(neighbor[1]) >= height {
						solution = neighbor[1]
					} else {
						solArray[1] = solution
						break
					}
				}
				return "Solution: \(solArray[0].format("+.2"))\t -> f(x) = \(f(solArray[0]).format("+.4"))\n" +
				"Solution: \(solArray[1].format("+.2"))\t -> f(x) = \(f(solArray[1]).format("+.4"))"
			} else if f(neighbor[0]) >= height {
				solution = neighbor[0]
			} else if f(neighbor[1]) >= height {
				solution = neighbor[1]
			} else {
				return "Solution: \(solution.format("+.2"))\t -> f(x) = \(f(solution).format("+.4"))"
			}
		}
	}
}

var f4 = {
	(x: Double) -> Double in
	-abs(x * x - 4)
}

x = 0
var sol = HillClimbing(f: f4, sol: x, step: dx)
//sol.report

var f5 = {
	(x: Double) -> Double in
	-abs(x * x - 5 * x + 6)
}
func f6(x: Double) -> Double {
	return -abs(x * x - 5 * x + 6)
}

x = 2
//sol = HillClimbing(f: f5, sol: x, step: dx)
//sol.report
x = 2.5
//sol = HillClimbing(f: f6, sol: x, step: dx)
//sol.report

/*:
### 模擬退火演算法

	Algorithm SimulatedAnnealing(s)
		while (溫度還不夠低，或還可以找到比s更好的解s'的時候)
			根據能量差與溫度，用機率的方式(ex. exp((e-e')/T))決定是否要移動到新解s'。
			將溫度降低一點
		end
	end

Pseudocode:

	Let s = s0
	For k = 0 through kmax (exclusive):
	T ← temperature(k ∕ kmax)
	Pick a random neighbour, snew ← neighbour(s)
	If P(E(s), E(snew), T) ≥ random(0, 1), move to the new state:
	s ← snew
	Output: the final state s
*/

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
	private mutating func update(newPoint: Point3D) {
		p = newPoint
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


func eq3D(p: Point3D) -> Double {
	let x = p.point.x
	let y = p.point.y
	let z = p.point.z
	return x * x + 3.0 * y * y + z * z - 4.0 * x - 3.0 * y - 5.0 * z + 8.0
}
func eq1D(p: Point3D) -> Double {
	let x = p.point.x
	return abs(x * x - 17.0)
}

// Try 1
var initialPoint3D: Point3D = Point3D(5, 5, 5)
var job = SimulatedAnnealing3D(equation: eq1D, initial: initialPoint3D, temp: 100, coolingRate: 0.003, step: 0.01, randomThreshold: true)
job = SimulatedAnnealing3D(equation: eq3D, initial: initialPoint3D, temp: 100, coolingRate: 0.003, step: 0.01, randomThreshold: true)
job.run()
job.description

// Try 2
initialPoint3D = Point3D(5, 0, 0)
job = SimulatedAnnealing3D(equation: eq1D, initial: initialPoint3D, temp: 100, coolingRate: 0.003, step: 0.01, randomThreshold: true)
job.run()
job.description

/*:
****
[Next](@next)
*/

