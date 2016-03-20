import Foundation

/*
* Models a city
*/

public struct City {
	var x: Double
	var y: Double
	var name: String
	
	// Constructs a randomly placed city
	public init(){
		self.x = 200.rand().toInt().toDouble()
		self.y = 200.rand().toInt().toDouble()
		self.name = "no name"
	}
	
	// Constructs a city at chosen x, y location
	public init(x: Double, y: Double, name: String = "no name"){
		self.x = x
		self.y = y
		self.name = name
	}
	
	public init(_ x: Double, _ y: Double, name: String = "no name"){
		self.x = x
		self.y = y
		self.name = name
	}
	
	// Gets city's x coordinate
	public func getX() -> Double {
		return self.x
	}
	
	// Gets city's y coordinate
	public func getY() -> Double {
		return self.y
	}
	private func getDistance(lat1: Double, long1: Double, lat2: Double, long2: Double) -> Double {
		func ConvertDegreeToRadians(degrees: Double) -> Double {
			return (M_PI/180) * degrees
		}
		let lat1r = ConvertDegreeToRadians(lat1)
		let lat2r = ConvertDegreeToRadians(lat2)
		let long1r = ConvertDegreeToRadians(long1)
		let long2r = ConvertDegreeToRadians(long2)
		let r_earth = 6371.0 // Earth's radius (km)
		let d = acos(sin(lat1r) * sin(lat2r) + cos(lat1r) * cos(lat2r) * cos(long2r-long1r)) * r_earth
		return d
	}
	private func getDistance(from: City, to: City) -> Double {
		return getDistance(from.x, long1: from.y, lat2: to.x, long2: to.y)
	}
	
	// Gets the distance to given city
	public func distanceTo(city: City) -> Double {
		return getDistance(self, to: city)
	}
	var description: String {
		return "\(name): (\(getX())" + ", \(getY()))"
	}
}

/*
* Holds the cities of a tour
*/

public class TourManager {
	// Holds our cities
	private static var destinationCities = [City]()
	// Adds a destination city
	public static func addCity(city: City) {
		destinationCities.append(city)
	}
	// Get a city
	public static func getCity(index: Int) -> City {
		return destinationCities[index]
	}
	// Get the number of destination cities
	public static func numberOfCities() -> Int{
		return destinationCities.count
	}
}

/*
* Stores a candidate tour through all cities
*/

public class Tour {
	// Holds our tour of cities
	private var tour = [City]()
	// Cache
	private var distance: Double = 0
	public init() {
		tourblank()
	}
	public init(tour: [City]) {
		self.tour = tour
	}
	// Constructs a blank tour
	public func tourblank() {
		for _ in 0..<TourManager.numberOfCities() {
			tour.append(City())
		}
	}
	// Constructs a tour from another tour
	public func tourClone(tour: [City]) {
		self.tour = tour
	}
	// Returns tour information
	public func getTour() -> [City] {
		return tour
	}
	// Creates a random individual
	public func generateIndividual() {
		// Loop through all our destination cities and add them to our tour
		for i in 0..<TourManager.numberOfCities() {
			tour[i] = TourManager.getCity(i)
		}
		// Randomly reorder the tour
		tour.randomize()
	}
	// Gets a city from the tour
	public func getCity(tourPosition: Int) -> City {
		return tour[tourPosition]
	}
	// Sets a city in a certain position within a tour
	public func setCity(tourPosition: Int, city: City) {
		tour[tourPosition] = city
		// If the tours been altered we need to reset the fitness and distance
		distance = 0
	}
	// Gets the total distance of the tour
	public func getDistance() -> Double {
		if (distance == 0) {
			var tourDistance: Double = 0
			// Loop through our tour's cities
			for i in 0..<tour.count {
				// Get city we're traveling from
				let fromCity = getCity(i)
				// City we're traveling to
				// Check we're not on our tour's last city, if we are set our
				// tour's final destination city to our starting city
				let destinationCity: City = i + 1 < tour.count ? getCity(i + 1) : getCity(0)
				// Get the distance between the two cities
				tourDistance += fromCity.distanceTo(destinationCity)
			}
			distance = tourDistance
		}
		return distance
	}
	// Get number of cities on our tour
	public func tourSize() -> Int {
		return tour.count
	}
	public var description: String {
		var geneString = "|"
		for i in 0..<tour.count {
			geneString += (getCity(i).description + "|")
		}
		return geneString
	}
}

/*
* SimulatedAnnealing
*/

public class SimulatedAnnealing {
	// Calculate the acceptance probability
	// 運用此機率函數的特性是溫度高時，能量值比最佳解更高的有更高的機率被接受，隨溫度降低，比最佳值高卻能通過的機率就會下降
	public static func acceptanceProbability(energy: Double, newEnergy: Double, temperature: Double) -> Double {
		// If the new solution is better, accept it
		if (newEnergy < energy) {
			return 1.0;
		}
		// If the new solution is worse, calculate an acceptance probability
		return exp((energy - newEnergy).toDouble() / temperature)
	}
	public static func addCities() {
		// Create and add our cities
		TourManager.addCity(City(x: 60, y: 200))
		TourManager.addCity(City(x: 180, y: 200))
		TourManager.addCity(City(x: 80, y: 180))
		TourManager.addCity(City(x: 140, y: 180))
		TourManager.addCity(City(x: 20, y: 160))
		TourManager.addCity(City(x: 100, y: 160))
		TourManager.addCity(City(x: 200, y: 160))
		TourManager.addCity(City(x: 140, y: 140))
		TourManager.addCity(City(x: 40, y: 120))
		TourManager.addCity(City(x: 100, y: 120))
		TourManager.addCity(City(x: 180, y: 100))
		TourManager.addCity(City(x: 60, y: 80))
		TourManager.addCity(City(x: 120, y: 80))
		TourManager.addCity(City(x: 180, y: 60))
		TourManager.addCity(City(x: 20, y: 40))
		TourManager.addCity(City(x: 100, y: 40))
		TourManager.addCity(City(x: 200, y: 40))
		TourManager.addCity(City(x: 20, y: 20))
		TourManager.addCity(City(x: 60, y: 20))
		TourManager.addCity(City(x: 160, y: 20))
	}
	
	public static func addTaiwanCities() {
		// Create and add our cities
		TourManager.addCity(City(22.626, 120.302, name: "Kaoshung"))
		TourManager.addCity(City(22.391, 120.068, name: "Pindong"))
		TourManager.addCity(City(25.068, 121.473, name: "Taipei"))
		TourManager.addCity(City(25.124, 121.647, name: "Keelung"))
		TourManager.addCity(City(24.855, 120.952, name: "Taoyuan"))
		TourManager.addCity(City(24.785, 120.887, name: "Hinchu"))
		TourManager.addCity(City(24.515, 120.800, name: "Miaoli"))
		TourManager.addCity(City(24.220, 120.676, name: "Taichung"))
		TourManager.addCity(City(23.734, 120.818, name: "Hualien"))
		TourManager.addCity(City(24.649, 121.361, name: "Yilan"))
		TourManager.addCity(City(23.992, 120.326, name: "Changhua"))
		TourManager.addCity(City(23.674, 120.294, name: "Yuanlin"))
		TourManager.addCity(City(21.980, 120.708, name: "Kending"))
		TourManager.addCity(City(22.722, 120.610, name: "Taidong"))
		TourManager.addCity(City(23.479, 120.414, name: "Chiayi"))
		TourManager.addCity(City(23.150, 120.066, name: "Tainan"))
	}
	
	public static func main() {
		addTaiwanCities()
		// Set initial temp
		var temp = 10000.0
		// Cooling rate
		let coolingRate = 0.003
		// Initialize intial solution
		var currentSolution: Tour = Tour()
		currentSolution.generateIndividual()
		print("Initial solution distance: " + currentSolution.getDistance().description)
		// Set as current best
		var best = Tour(tour: currentSolution.getTour())
		// Loop until system has cooled
		while (temp > 1) {
			// Create new neighbour tour
			let newSolution = Tour(tour: currentSolution.getTour())
			// Get a random positions in the tour
			let tourPos1: Int = newSolution.tourSize().rand().toInt()
			let tourPos2: Int = newSolution.tourSize().rand().toInt()
			// Get the cities at selected positions in the tour
			let citySwap1 = newSolution.getCity(tourPos1)
			let citySwap2 = newSolution.getCity(tourPos2)
			// Swap them
			newSolution.setCity(tourPos2, city: citySwap1)
			newSolution.setCity(tourPos1, city: citySwap2)
			// Get energy of solutions
			let currentEnergy = currentSolution.getDistance()
			let neighbourEnergy = newSolution.getDistance()
			let randomNumber: Double = arc4random().toDouble() / UInt32.max.toDouble()  //此數值會影響結果(求解的品質)
			// Decide if we should accept the neighbour
			if (acceptanceProbability(currentEnergy, newEnergy: neighbourEnergy, temperature: temp) > randomNumber) {
				currentSolution = Tour(tour: newSolution.getTour())
			}
			// Keep track of the best solution found
			if (currentSolution.getDistance() < best.getDistance()) {
				best = Tour(tour: currentSolution.getTour())
			}
			
			// Cool system
			temp *= 1 - coolingRate
		}
		print("Final solution distance: " + best.getDistance().description)
		print("Tour: " + best.description)
	}
}

//SimulatedAnnealing.main()