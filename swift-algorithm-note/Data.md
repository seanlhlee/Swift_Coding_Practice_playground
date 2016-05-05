[Previous](Preface.md) | 回到[目錄](SUMMARY.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Data.html#1) | [Next](Array.md)
_____________________
# Data
_____________________
## Data
英文的「 Data 」是複數形，是指大量資料，而非一筆資料。

中文的「資料」，大家國文造詣都很棒，應該都知道是什麼意思。不過為求慎重，還是查一下國語字典吧：
	__________________________________________________
	一、可供參考或研究的材料。如：「第一手資料」、「原始資料」。
	二、生產、生活中必需的東西。如：「生產資料」、「生活資料」。
	三、在社會科學中，指研究者對社會現象中某些事實所作的紀錄。
	四、計算機中一切數值、記號和事實的概稱。通常指未加以處理者。
	__________________________________________________

聽起來有點複雜，就當我沒查吧。

簡單來說，計算機拿來儲存、拿來計算的東西，就叫做資料。
_____________________
## 程式語言的變數


「資料」聽起來不明不白，有點抽象。對於初學者來說，從程式語言的變數入手，會比較有感覺。
```swift
// 一個整數，它是一筆資料。
let i: Int = 0

// 一個字串，它是一筆資料。
let str: String = "Hello World!"

// 一個boolean，它是一筆資料。
let b: Bool = false

// 一個座標，它是一筆資料。
struct Point { var x, y: Int }
let point = Point(x: 2, y: 3)

// 一顆從別處偷借來的球，它是一筆資料。
struct Ball {
	private var _radius: Double // 半徑
	private var _name: String   // 名稱
	
	var radius: Double {
		get {
			return _radius
		}
		set {
			self._radius = newValue
		}
	}
	var name: String {
		get {
			return _name
		}
		set {
			self._name = newValue
		}
	}
	var volumn: Double {
		return 4.0 / 3.0 * M_PI * _radius * _radius * _radius
	}
}

let ball = Ball(_radius: 3.0, _name: "my ball")
ball.volumn		//113.097
```
上面這些都是一筆資料的Swift程式碼範例。可是如果有非常多筆資料怎麼辦呢？
```swift
// 五筆資料
let i1 = 1, i2 = 1, i3 = 1, i4 = 1, i5 = 1
```
可是如果有一萬筆、一億筆資料怎麼辦呢？

是的，這時候你就必須學習「資料結構 Data Structure 」。要不然你會抓狂的。

資料結構是資料的儲存方式。資料結構的用途，是讓我們計算資料的時候，可以簡便地、快速地存取資料。

由於坊間已有許多圖文並茂的資料結構書籍，以下不再重複整理，僅做重點介紹。

_____________________
* [用十分鐘 學會【資料結構、演算法和計算理論】](http://www.slideshare.net/ccckmit/ss-56891871)
_____________________
[Previous](Preface.md) | 回到[目錄](SUMMARY.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Data.html#1) | [Next](Array.md)