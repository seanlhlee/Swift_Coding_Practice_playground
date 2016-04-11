import Foundation
import MapKit
import XCPlayground

// MKAnnotation: Annotation Title get from the caller view's restorationIdentifier
extension MKMapView: MKAnnotation {
	public var coordinate: CLLocationCoordinate2D {
		return self.centerCoordinate
	}
	public var title: String? {
		get {
			return self.restorationIdentifier
		}
	}
}

/*
 *	Models a city
 */
public struct TaiwanCity {
	let shortCityName: [String: String] = ["基隆" : "基隆市", "台北" : "台北市中正區", "新北" : "新北市板橋區", "桃園" : "桃園縣桃園市", "新竹" : "新竹市", "苗栗" : "苗栗縣苗栗市", "台中" : "台中市西屯區", "彰化" : "彰化縣彰化市", "南投" : "南投縣南投市", "雲林" : "雲林縣斗六市", "嘉義" : "嘉義縣嘉義市", "台南" : "台南市安平區", "高雄" : "高雄市", "屏東" : "屏東縣屏東市", "恒春" : "屏東縣恒春鎮", "恆春" : "屏東縣恒春鎮", "台東" : "台東縣台東市", "花蓮" : "花蓮縣花蓮市", "宜蘭" : "宜蘭縣宜蘭市", "澎湖" : "澎湖縣馬公市", "連江" : "連江縣", "馬祖" : "連江縣", "金門" : "金門縣"]
	var city: String
	var name: String {
		if let name = shortCityName[city] {
			return name
		}
		return city
	}
	var latitude: Double {
		return GPSData.getGPSData(name).lat
	}
	var longitude: Double {
		return GPSData.getGPSData(name).long
	}
	//	struct CLLocationCoordinate2D { var latitude: CLLocationDegrees var longitude: CLLocationDegrees init()
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(
			latitude: latitude, longitude: longitude)
	}
	// Construct the mapView with pin annotation of the city
	var mapView: MKMapView {
		// set the zoom
		let delta = 0.05	//city's view (+- 0.05 deg)
		// set the size of the map
		let frame = CGRect( x:0, y:0, width:400, height:600 )
		let view = MKMapView(frame: frame)
		// create and populate a coordinate region struct
		var region = MKCoordinateRegion()
		region.center.latitude = latitude
		region.center.longitude = longitude
		// span defines the zoom
		region.span.latitudeDelta = delta
		region.span.longitudeDelta = delta
		// inform the mapView of these edits
		view.setRegion(region, animated: true)
		// set a restorationIdentifier string for annotating the city
		view.restorationIdentifier = city
		view.addAnnotation(view)
		return view
	}
	// Constructs a randomly placed city
	public init(){
		self.city = "no name"
	}
	// Constructs a city by the city name in Taiwan
	public init(city: String) {
		self.city = city
	}
	// Gets city's longitude coordinate
	public func getLongitude() -> Double {
		return self.longitude
	}
	// Gets city's latitude coordinate
	public func getLatitude() -> Double {
		return self.latitude
	}
	// Gets distance between to locations using its coordinate
	private func getDistance(lat1: Double, long1: Double, lat2: Double, long2: Double) -> Double {
		func ConvertDegreeToRadians(degrees: Double) -> Double {
			return (M_PI/180) * degrees
		}
		let lat1r = ConvertDegreeToRadians(lat1)
		let lat2r = ConvertDegreeToRadians(lat2)
		let long1r = ConvertDegreeToRadians(long1)
		let long2r = ConvertDegreeToRadians(long2)
		let r_earth = 6378137.0 // Earth's radius (m)
		let d = acos(sin(lat1r) * sin(lat2r) + cos(lat1r) * cos(lat2r) * cos(long2r-long1r)) * r_earth
		return d
	}
	// Gets distance between to two cities.
	private func getDistance(from: TaiwanCity, to: TaiwanCity) -> Double {
		return getDistance(from.latitude, long1: from.longitude, lat2: to.latitude, long2: to.longitude)
	}
	
	// Gets the distance to given city
	public func distanceTo(city: TaiwanCity) -> Double {
		return getDistance(self, to: city)
	}
	// Get mapview of the city
	public func getMapView() -> MKMapView {
		return mapView
	}
	// Brift description of the city
	var description: String {
		return "\(name): (\(getLatitude())" + ", \(getLongitude()))"
	}
}

/*
 *	Holds the cities of a tour
 */

public class TourManagerTaiwan {
	// Holds our cities
	private static var destinationCities = [TaiwanCity]()
	// Adds a destination city
	public static func addCity(city: TaiwanCity) {
		destinationCities.append(city)
	}
	// Get a city
	public static func getCity(index: Int) -> TaiwanCity {
		return destinationCities[index]
	}
	// Get the number of destination cities
	public static func numberOfCities() -> Int{
		return destinationCities.count
	}
}

/*
 *	Stores a candidate tour through all cities
 */

public class Tour {
	// Holds our tour of cities
	private var tour = [TaiwanCity]()
	// Cache
	private var distance: Double = 0
	// initialize with a tour contains blank cities.
	public init() {
		tourblank()
	}
	// initialize with an existing tour.
	public init(tour: [TaiwanCity]) {
		self.tour = tour
	}
	// Constructs a blank tour
	public func tourblank() {
		for _ in 0..<TourManagerTaiwan.numberOfCities() {
			tour.append(TaiwanCity())
		}
	}
	// Constructs a tour from another tour
	public func tourClone(tour: [TaiwanCity]) {
		self.tour = tour
	}
	// Returns tour information
	public func getTour() -> [TaiwanCity] {
		return tour
	}
	// Creates a random individual
	public func generateIndividual() {
		// Loop through all our destination cities and add them to our tour
		for i in 0..<TourManagerTaiwan.numberOfCities() {
			tour[i] = TourManagerTaiwan.getCity(i)
		}
		// Randomly reorder the tour
		tour.randomize()
	}
	// Gets a city from the tour
	public func getCity(tourPosition: Int) -> TaiwanCity {
		return tour[tourPosition]
	}
	// Sets a city in a certain position within a tour
	public func setCity(tourPosition: Int, city: TaiwanCity) {
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
				let destinationCity: TaiwanCity = i + 1 < tour.count ? getCity(i + 1) : getCity(0)
				// Get the distance between the two cities
				tourDistance += fromCity.distanceTo(destinationCity)
			}
			distance = tourDistance
		}
		return distance
	}
	// Gets number of cities on our tour
	public func tourSize() -> Int {
		return tour.count
	}
	// Simple description
	public var description: String {
		var geneString = "|"
		for i in 0..<tour.count {
			geneString += (getCity(i).description + "|")
		}
		return geneString
	}
	// a mapview of the tour, contains cities and all annotations.
	public var mapView: MKMapView {
		// set the zoom
		let delta = 5.00   // +/- 5 deg to view all destinations on the mapView.
		// set the size of the map
		let frame = CGRect( x:0, y:0, width:400, height:600 )
		let view = MKMapView(frame: frame)
		// create and populate a coordinate region struct
		var region = MKCoordinateRegion()
		// set the map region to a suitable location @(N23.5, E120.0)
		region.center.latitude = 23.5
		region.center.longitude = 120.0
		// span defines the zoom
		region.span.latitudeDelta = delta
		region.span.longitudeDelta = delta
		// inform the mapView of these edits
		view.setRegion(region, animated: true)
		// set the title string of annotations. Format: #of the tour: city name
		var annotations: [MKAnnotation] {
			var array: [MKAnnotation] = []
			for i in 0..<tour.count {
				let view = getCity(i).mapView
				view.restorationIdentifier = "\(i):" + view.restorationIdentifier!
				array.append(view)
			}
			return array
		}
		view.addAnnotations(annotations)
		return view
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
	public static func addTaiwanCities() {
		// Create and add our cities
		TourManagerTaiwan.addCity(TaiwanCity(city: "高雄"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "屏東"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "台北"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "基隆"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "桃園"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "新竹"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "苗栗"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "台中"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "花蓮"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "宜蘭"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "彰化"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "雲林"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "恒春"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "台東"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "嘉義"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "台南"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "新北"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "金門"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "澎湖"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "南投"))
		TourManagerTaiwan.addCity(TaiwanCity(city: "連江"))
	}
	// Use this function to get better solutions if needed based on there is a solution.
	public static func main(givenSolution: Tour) -> Tour {
		// Set initial temp
		var temp = 10000.0
		// Cooling rate
		let coolingRate = 0.003
		// Initialize intial solution
		var currentSolution: Tour = givenSolution
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
		return best
	}
	// Use this function to get a solution for the first time calculation from a unknown tour.
	public static func main() -> Tour {
		// addTaiwanCities()
		addTaiwanCities()
		let currentSolution: Tour = Tour()
		currentSolution.generateIndividual()
		return main(currentSolution)
	}
}