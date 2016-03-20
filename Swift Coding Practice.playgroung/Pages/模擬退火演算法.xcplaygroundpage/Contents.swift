/*: 
[Previous](@previous)
****
# 模擬退火

模擬退火是一種通用機率演算法，用來在固定時間內尋求在一個大的搜尋空間內找到的最優解。模擬退火是S. Kirkpatrick, C. D. Gelatt和M. P. Vecchi在1983年所發明。而V. Černý在1985年也獨立發明此演算法。

## 簡介

模擬退火來自冶金學的專有名詞退火。退火是將材料加熱後再經特定速率冷卻，目的是增大晶粒的體積，並且減少晶格中的缺陷。材料中的原子原來會停留在使內能有局部最小值的位置，加熱使能量變大，原子會離開原來位置，而隨機在其他位置中移動。退火冷卻時速度較慢，使得原子有較多可能可以找到內能比原先更低的位置。

模擬退火的原理也和金屬退火的原理近似：我們將熱力學的理論套用到統計學上，將搜尋空間內每一點想像成空氣內的分子；分子的能量，就是它本身的動能；而搜尋空間內的每一點，也像空氣分子一樣帶有「能量」，以表示該點對命題的合適程度。演算法先以搜尋空間內一個任意點作起始：每一步先選擇一個「鄰居」，然後再計算從現有位置到達「鄰居」的機率。

可以證明，模擬退火算法所得解依機率收斂到全局最優解。

## 演算步驟

#### 初始化

生成一個可行的解作為當前解輸入疊代過程，並定義一個足夠大的數值作為初始溫度。

#### 疊代過程

疊代過程是模擬退火算法的核心步驟，分為新解的產生和接受新解兩部分：

由一個產生函數從當前解產生一個位於解空間的新解；為便於後續的計算和接受，減少算法耗時，通常選擇由當前新解經過簡單地變換即可產生新解的方法，如對構成新解的全部或部分元素進行置換、互換等，注意到產生新解的變換方法決定了當前新解的鄰域結構，因而對冷卻進度表的選取有一定的影響。
1. 計算與新解所對應的目標函數差。因為目標函數差僅由變換部分產生，所以目標函數差的計算最好按增量計算。事實表明，對大多數應用而言，這是計算目標函數差的最快方法。
2. 判斷新解是否被接受，判斷的依據是一個接受準則，最常用的接受準則是Metropolis準則：若Δt′<0則接受S′作為新的當前解S，否則以機率exp（-Δt′/T）接受S′作為新的當前解S。
3. 當新解被確定接受時，用新解代替當前解，這只需將當前解中對應於產生新解時的變換部分予以實現，同時修正目標函數值即可。此時，當前解實現了一次疊代。可在此基礎上開始下一輪試驗。而當新解被判定為捨棄時，則在原當前解的基礎上繼續下一輪試驗。
4. 模擬退火算法與初始值無關，算法求得的解與初始解狀態S（是算法疊代的起點）無關；模擬退火算法具有漸近收斂性，已在理論上被證明是一種以機率1收斂於全局最優解的全局優化算法；模擬退火算法具有並行性。

#### 停止準則

疊代過程的停止準則：溫度T降至某最低值時，完成給定數量疊代中無法接受新解，停止疊代，接受當前尋找的最優解為最終解。

#### 退火方案

在某個溫度狀態T下，當一定數量的疊代操作完成後，降低溫度T，在新的溫度狀態下執行下一個批次的疊代操作。

#### 偽代碼(Pseudocode)

尋找能量E（s）最低的狀態s

	s := s0; e := E (s)                           // 設定目前狀態為s0，其能量E (s0)
	k := 0                                       // 評估次數k
	while k < kmax and e > emax                  // 若還有時間（評估次數k還不到kmax）且結果還不夠好（能量e不夠低）則：
	sn := neighbour (s)                         //   隨機選取一鄰近狀態sn
	en := E (sn)                                //   sn的能量為E (sn)
	if random() < P(e, en, temp(k/kmax)) then  //   決定是否移至鄰近狀態sn
	s := sn; e := en                         //     移至鄰近狀態sn
	k := k + 1                                 //   評估完成，次數k加一
	return s                                     // 回傳狀態s

應用: 旅行推銷員問題

![](http://www.theprojectspot.com/images/post-assets/hc_1.jpg "")

![](http://www.theprojectspot.com/images/post-assets/map1.jpg "")

*/
import Foundation

/*
* Models a city
*/

public struct City {
	var x: Int
	var y: Int
	
	// Constructs a randomly placed city
	public init(){
		self.x = 200.rand().toInt()
		self.y = 200.rand().toInt()
	}
	
	// Constructs a city at chosen x, y location
	public init(x: Int, y: Int){
		self.x = x
		self.y = y
	}
	
	// Gets city's x coordinate
	public func getX() -> Int{
		return self.x
	}
	
	// Gets city's y coordinate
	public func getY() -> Int{
		return self.y;
	}
	
	// Gets the distance to given city
	public func distanceTo(city: City) -> Double {
		let xDistance = abs(self.getX() - city.getX())
		let yDistance = abs(self.getY() - city.getY())
		return sqrt((xDistance * xDistance + yDistance * yDistance).toDouble())
	}
	var description: String {
		return "(\(getX())" + ", \(getY()))"
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
	
	public static func main() {
		addCities()
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

/*:
[Origin Result]:http://www.theprojectspot.com/tutorial-post/simulated-annealing-algorithm-for-beginners/6 ""

[Origin Result] reported on the project spot.

![](http://www.theprojectspot.com/images/post-assets/sa_complete.jpg "")

Initial solution distance: 1966

Final solution distance: 911

Tour: |180, 200|200, 160|140, 140|180, 100|180, 60|200, 40|160, 20|120, 80|100, 40|60, 20|20, 20|20, 40|60, 80|100, 120|40, 120|20, 160|60, 200|80, 180|100, 160|140, 180|

****
Test 1:

Tour: |140, 180|180, 200|200, 160|140, 140|180, 100|180, 60|200, 40|160, 20|100, 40|120, 80|100, 160|80, 180|60, 200|20, 160|40, 120|20, 40|20, 20|60, 20|60, 80|100, 120|
****
Test 2:

Initial solution distance: 2004.48996122319

Final solution distance: 1005.24074500042

Tour: |100, 160|80, 180|60, 200|20, 160|40, 120|60, 80|100, 40|60, 20|20, 20|20, 40|100, 120|140, 140|140, 180|180, 200|200, 160|180, 100|200, 40|180, 60|160, 20|120, 80|

****
Test 3:

Initial solution distance: 2004.48996122319

Final solution distance: 1098.76755880898

Tour: |20, 160|60, 200|80, 180|200, 40|180, 60|180, 100|200, 160|180, 200|140, 180|140, 140|100, 160|100, 120|60, 80|120, 80|160, 20|100, 40|60, 20|20, 20|20, 40|40, 120|

*****
[Next](@next)
*/
