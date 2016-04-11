/*:
# The Traveling Salesman with Simulated Annealing
## This page demonstrates solving the shortest path of travel itinerary by using Simulated Annealing method.
	
- You can copy the code written in the `../Sources/TourManagerTaiwan.swift` to this page, if you want to observe the process of sloving.
- You will get a mapView show in Timeline frame, if you want to see the map, please enable the assistant editor and set it to show Timeline.
- You can see a number folowing with a name of a city. The number indicates the city is the n'th destination of this tour.

![](mapview.png "")

*/

import UIKit
import MapKit
import XCPlayground


let best = SimulatedAnnealing.main()

XCPlaygroundPage.currentPage.liveView = best.mapView


