/*:
[Previous](@previous)
_____________________
# Enumeration
### 愚者千慮，必有一得。《史記》
_____________________
## Enumeration
「枚舉法」利用了電腦無與倫比的計算速度。找到不確定的變數，枚舉所有可能性，逐一判斷正確性。

	__________________________
	Enumerate
	一筆一筆列出所有資料。
	對應到程式語言的for。

	Search
	瀏覽所有資料，找出需要的部份。
	對應到程式語言的for加if。
	__________________________

收集充分資訊，就能解決問題。

![](Enumeration1.png "")

## 範例：枚舉一百個平方數
_____________________
採用直接法：依序枚舉數字 1 到 100 ；枚舉過程當中，將數字平方得到平方數。

![](Enumeration2.png "")

	void generate_squares() {
		for (int i=1; i<=100; i++)
			cout << i*i << "是平方數";
	}
*/
// ToDo Swift Code
func print_squares(n: Int) {
	for i in 0...n {
		print("Square of interger \(i) is \(i * i)")
	}
}
print_squares(10)
/*:
採用試誤法：依序枚舉數字 1 到 ∞ ；枚舉過程當中，判斷數字是不是平方數。

![](Enumeration3.png "")

	void generate_squares() {
		for (int i=1; i<=100*100; i++) {
			int sqrt_i = sqrt(i);
			if (sqrt_i * sqrt_i == i)
				cout << i << "是平方數";
		}
	}
*/
// ToDo Swift Code
import Foundation
func square_test(n: Int) {
	for i in 0...n {
		let j = Int(sqrt(Double(i)))
		if j * j == i {
			print("\(i) is a square number of an interanger")
		}
	}
}
square_test(100)
/*:
## 範例：尋找陣列裡的最小值
_____________________
由小到大枚舉陣列索引值，逐一比較陣列元素。

![](Enumeration4.png "")

	void find_minimum() {
			int array[5] = {3, 6, 9, -8, 1};
			int min = 2147483647;
			for (int i=0; i<5; i++) // 枚舉索引值
				if (array[i] < min) // 比較元素
					min = array[i]; // 隨時紀錄最小值
			cout << "最小的數字是" << min;
	}
*/
// ToDo Swift Code
func findMin(array: [Int]) -> Int {
	var min: Int = Int.max
	for a in array {
		min = a < min ? a : min
	}
	print("The minimum interger in array is \(min)")
	return min
}
let findMinArray = [3, 6, 9, -8, 1]
findMin(findMinArray)
/*:
	int find_minimum(int array[], int n) {
		int min = 2147483647;
		for (int i=0; i<n; i++) // 枚舉索引值
			if (array[i] < min) // 比較元素
				min = array[i]; // 隨時紀錄最小值
		return min;
	}
*/
// ToDo Swift Code
/*:
## 範例：尋找陣列裡的特定數字
_____________________
找到所有特定數字：瀏覽一遍所有數字。

![](Enumeration5.png "")

	void find_all_number() {
		int array[5] = {3, 6, 9, -8, 1};
		for (int i=0; i<5; i++) // 枚舉
			if (array[i] == 6)  // 搜尋
				cout << i << ':' << array[i] << '\n';
	}
*/
// ToDo Swift Code
func findSix(array: [Int]) -> (idx: Int?, num: Int?) {
	var idx: Int?, num: Int? = nil
	for i in 0..<array.count {
		if array[i] == 6 {
			num = 6
			idx = i
			break
		}
	}
	return (idx, num)
}
findSix(findMinArray)
let xxx = [3, 5, 9, -8, 1]
findSix(xxx)
/*:
找到其中一個特定數字：一旦找到，立即停止瀏覽，以節省時間。

![](Enumeration6.png "")

	bool find_number() {
		int array[5] = {3, 6, 9, -8, 1};
		for (int i=0; i<5; i++) // 枚舉
			if (array[i] == 6)  // 搜尋 {
				cout << i << ':' << array[i];
				break;
		}
	}
*/
// ToDo Swift Code
/*:
	int find_number(int array[i], int n, int num) {
		for (int i=0; i<n; i++)
			if (array[i] == num)
				return i;
		return -1;
	}
*/
// ToDo Swift Code
func findNumber(n: Int, inArray: [Int]) -> (idx: Int?, num: Int?) {
	var idx: Int?, num: Int? = nil
	for i in 0..<inArray.count {
		if inArray[i] == n {
			num = n
			idx = i
			break
		}
	}
	return (idx, num)
}
findNumber(5, inArray: findMinArray)
findNumber(-8, inArray: findMinArray)
/*:
## 範例：尋找二維陣列裡的特定數字
_____________________

![](Enumeration7.png "")

多個元素成為一個橫條、多個橫條成為一個陣列。內層先枚舉元素，外層再枚舉橫條，就能枚舉所有元素。

方才是由內而外、由小到大進行思考，其實也可以由外而內、由大到小進行思考：外層先枚舉每一個橫條，內層再枚舉一個橫條的每一個元素，就能枚舉所有元素。

	bool find(int n) {
		int array[3][5] = {
				{3, 6, 9, -8, 1},
				{2, 4, 6, 8, 10},
				{11, 7, 5, 3, 2}
		};
		// 外層枚舉每一個橫條
		for (int i=0; i<3; i++)
			// 內層枚舉一個橫條的每一個元素
			for (int j=0; j<5; j++)
				// 就能枚舉所有元素
				if (array[i][j] == n)
					return true;
		return false;
	}
*/
// ToDo Swift Code
var array2D = [[3, 6, 9, -8, 1], [2, 4, 6, 8, 10], [11, 7, 5, 3, 2]]
func find(n: Int, in2DArray: [[Int]]) -> (idx: (x: Int?,y: Int?), num: Int?) {
	var x: Int?, y: Int? , num: Int? = nil
	for i in 0..<in2DArray.count {
		for j in 0..<in2DArray[i].count {
			if in2DArray[i][j] == n {
				num = n
				x = i
				y = j
				break
			}
		}
		if x != nil {
			break
		}
	}
	return ((x,y), num)
}
find(8, in2DArray: array2D)
/*:
此處再介紹一種特別的思考方式：第一層枚舉每一個橫條，第二層枚舉每一個直條，就能枚舉所有直條與橫條的交錯之處。

雖然前後兩個思考方式完全不同，但是前後兩支程式碼卻完全相同。

	bool find(int n) {
		int array[3][5] = {
				{3, 6, 9, -8, 1},
				{2, 4, 6, 8, 0},
				{7, 5, 3, 2, 1}
		};
		// 第一層枚舉每一個橫條
		for (int i=0; i<3; i++)
			// 第二層枚舉每一個直條
			for (int j=0; j<5; j++)
				// 就能枚舉所有橫條與直條交錯之處
				if (array[i][j] == n)
					return true;
		return false;
	}
*/
// ToDo Swift Code
/*:
## 範例：平面上距離最近的兩個點（ Closest Pair Problem ）
_____________________

![](Enumeration8.png "")

第一層枚舉第一個點，第二層枚舉第二個點。為了避免重複枚舉相同的一對點，第二層只枚舉索引值更高的點。

	void closest_pair() {
		float point[10][2] = {
				{3, 3}, {1, 5}, {4, 6}, {2, 8}, {9, 9},
				{2, 1}, {7, 2}, {6, 5}, {9, 4}, {5, 9}
		};
		// 距離最近的兩個點的距離
		float d = 1e9;
		// 枚舉第一點
		for (int i=0; i<10; i++)
		// 枚舉第二點
		for (int j=i+1; j<10; j++) {
			// 計算第一點到第二點的距離
			float dx = point[i][0] - point[j][0];
			float dy = point[i][1] - point[j][1];
			float dij = sqrt(dx * dx + dy * dy);
			// 紀錄最短的距離
			if (dij < d) d = dij;
		}
		cout << "距離是" << d;
	}
*/
// ToDo Swift Code
let points = [[3, 3], [1, 5], [4, 6], [2, 8], [9, 9], [2, 1], [7, 2], [6, 5], [9, 4], [5, 9]]
func closest(inPoints: [[Int]]) -> (pair: (p1: [Int], p2: [Int]), distance: Double) {
	var p1: [Int] = [0, 0]
	var p2: [Int] = [0, 0]
	var distance = Double(Int.max)
	for i in 0..<inPoints.count - 1 {
		for j in (i + 1)..<inPoints.count {
			let dx = inPoints[i][0] - inPoints[j][0]
			let dy = inPoints[i][1] - inPoints[j][1]
			let dij = sqrt(Double(dx * dx + dy * dy))
			if dij < distance {
				distance = dij
				p1 = inPoints[i]
				p2 = inPoints[j]
			}
		}
	}
	return ((p1, p2), distance)
}
closest(points).pair.p1
closest(points).pair.p2
closest(points).distance

/*:
可以把計算距離的程式碼，抽離出來成為一個函式。好處是程式碼變得清爽許多，增加程式碼可讀性。壞處是大量呼叫函式，導致執行速度變慢。

	struct Point {float x, y;};

	// 計算兩點之間的距離
	float dist(Point& a, Point& b) {
		float dx = a.x - b.x;
		float dy = a.y - b.y;
		return sqrt(dx * dx + dy * dy);
	}

	void closest_pair() {
		Point point[10] = {
				{3, 3}, {1, 5}, {4, 6}, {2, 8}, {9, 9},
				{2, 1}, {7, 2}, {6, 5}, {9, 4}, {5, 9}
		};
		float d = 1e9;
		for (int i=0; i<10; i++)
			for (int j=i+1; j<10; j++)
				// 紀錄最短的距離
				d = min(d, dist(point[i], point[j]));
		cout << "距離是" << d;
	}
*/
// ToDo Swift Code
func distance(p1: [Int], p2: [Int]) -> Double {
	let dx = p1[0] - p2[0]
	let dy = p1[1] - p2[1]
	return sqrt(Double(dx * dx + dy * dy))
}
func closest_1(inPoints: [[Int]]) -> (pair: (p1: [Int], p2: [Int]), d: Double) {
	var p1: [Int] = [0, 0]
	var p2: [Int] = [0, 0]
	var d = Double(Int.max)
	for i in 0..<inPoints.count - 1 {
		for j in (i + 1)..<inPoints.count {
			let dij = distance(inPoints[i], p2: inPoints[j])
			if dij < d {
				d = dij
				p1 = inPoints[i]
				p2 = inPoints[j]
			}
		}
	}
	return ((p1, p2), d)
}
closest_1(points).pair.p1
closest_1(points).pair.p2
closest_1(points).d
/*:
魚與熊掌不可兼得，這兩種程式碼各有優缺點，沒有絕對的好壞。程式員必須自行取捨。

## 範例：字串匹配（ String Matching ）
_____________________
從長字串之中，找到短字串的出現位置。

![](Enumeration9.png "")

第一層先枚舉所有可以匹配的位置，第二層再枚舉所有需要匹配的字元。

	void string_matching() {
		char text[15] = "It's a pencil.";
		char pattern[6] = "a pen";
		// 枚舉所有可以匹配的位置
		for (int i=0; i<14; i++) {
			// 枚舉所有需要匹配的字元
			bool match = true;
			for (int j=0; j<5; j++)
				if (text[i+j] != pattern[j])
					match = false;
			if (match)
				cout << "短字串出現在第" << i << "個字元";
		}
	}
*/
// ToDo Swift Code
func findTa(str: String, inStr: String) -> Int? {
	let length = str.characters.count
	var tar: [Character] = Array(str.characters)
	var sou: [Character] = Array(inStr.characters)
	for i in 0..<sou.count - length + 1 {
		var f: Bool = true
		for j in 0..<tar.count {
			if sou[i + j] != tar[j] {
				f = false
				break
			}
		}
		if f {return i}
	}
	return nil
}
findTa("a pen", inStr: "It's a pencil.")
findTa("a pan", inStr: "It's a pencil.")
findTa(".", inStr: "It's a pencil.")
/*:
因為短字串不會超出長字串末段，所以第一層枚舉範圍可以再略微縮小。

因為只要一個相異字元，就足以表明匹配位置錯誤，所以第二層的枚舉過程可以提早結束。

	void string_matching() {
		char text[14] = "It's a pencil.";
		char pattern[6] = "a pen";
		// 仔細估量枚舉範圍
		for (int i=0; i<14-6+1; i++) {
			bool match = true;
			for (int j=0; j<5; j++)
				if (text[i+j] != pattern[j]) {
					match = false;
					break;
				}
			
			if (match)
				cout << "短字串出現在第" << i << "個字元";
		}
	}
*/
// ToDo Swift Code
/*:
## 範例：統計字母數量
_____________________

![](Enumeration10.png "")

第一層先枚舉 26 種英文字母，第二層再枚舉字串的所有字元，計算一種字母的數量。

	void count_letter() {
		char s[15] = "Hello World!";
		// 字母統一換成小寫
		for (int i=0; s[i]; i++)
			if (s[i] >= 'A' && s[i] <= 'Z')
				s[i] = s[i] - 'A' + 'a';
		// 枚舉26種英文字母
		for (int i=0; i<26; i++) {
			// 枚舉字串的所有字元
			int c = 0;
			for (int j=0; s[j]; j++)
				if (s[j] == 'a' + i)
					c++;
			// 印出一種字母的數量
			cout << (char)('a' + i) << ':' << c;
		}
	}
*/
// ToDo Swift Code
var hello = "Hello, World"   // A -> 65, a -> 97
func countCharacter(str: String) -> [Int] {
	var array = [Int](count: 27, repeatedValue: 0)
	for scalar in str.unicodeScalars {
		var i: Int = (scalar.value < 65 || scalar.value > 122) ? 91 : Int(scalar.value)  // not a~z | A~Z -> 91 -> 26
		i = (i >= 97) ? (i - 97) : (i - 65)
		array[i] += 1
	}
	for i in 0..<array.count {
		print("\(Character(UnicodeScalar(65 + i)))", separator: "", terminator: ": \(array[i])\t\t")
		if i % 5 == 4 {
			print("\n", separator: "", terminator: "")
		}
	}
	return array
}
let charArray = countCharacter(hello)
print("")
countCharacter("The best way to predict the future is to invent it.")
/*:
先前曾經介紹過統計字母數量的範例。先前範例當中，雖然耗費記憶體空間，但是執行速度快──簡單來說就是空間大、時間小。此處範例當中，則是空間小，時間大，恰恰相反。這兩種方式各有優缺點，程式員必須自行取捨。

## 範例：反轉字串
_____________________

![](Enumeration11.png "")

兩個枚舉，一個從頭到尾，一個從尾到頭，步調相同，逐步對調字元。雖然是兩個枚舉，卻只有一個迴圈。

	void reverse_string(){
			char s[15] = "Hello World!";
			// 兩個枚舉，一個從頭到尾，一個從尾到頭。
			for (int i=0, j=12; i<j; i++, j--)
				swap(s[i], s[j]);
			cout << "反轉之後的字串是" << s;
	}
*/
// ToDo Swift Code
func reverse(str: String) -> String {
	var array: [Character] = Array(str.characters)
	for (var i = 0, j = array.count - 1; i < j; i += 1, j -= 1) {

		swap(&array[i], &array[j])
	}
	return String(array)
}
reverse(hello)
reverse("The best way to predict the future is to invent it.")
/*:
	void reverse(char* s) {
		int n = strlen(s);
		for (int i=0; i<n/2; i++)
			swap(s[i], s[n-1-i]);
	}
*/
// ToDo Swift Code
func reverse_1(str: String) -> String {
	var array: [Character] = Array(str.characters)
	for i in 0..<array.count / 2 {
		swap(&array[i], &array[array.count - 1 - i])
	}
	return String(array)
}
reverse_1(hello)
reverse_1("The best way to predict the future is to invent it.")
/*:
[1595]:http://uva.onlinejudge.org/external/15/1595.html ""
_____________________
UVa [1595]
_____________________
## 範例：尋找總和為 10 的區間
_____________________
假設陣列元素只有正數。

![](Enumeration12.png "")

兩個枚舉，枚舉區間左端以及枚舉區間右端，都是從頭到尾，保持一左一右，視情況輪流枚舉。雖然是兩個枚舉，卻只有一個迴圈。


	void find_interval() {
		int array[5] = {3, 6, 1, 7, 2};
		int sum = 0;
		for (int i=0, j=-1; j<5; )  // 枚舉區間[i, j] {
			if (sum > 10) {
				// 總和太大，區間左端往右縮短。
				sum -= array[i];
				i++;
			}
			else if (sum < 10) {
				// 總和太小，區間右端往右伸長。
				j++;
				sum += array[j];
			}
			else if (sum == 10) {
				// 總和剛好，
				// 區間左端往右縮短，
				// 亦得區間右端往右伸長。
				// 任選一種皆可。
				//          sum -= array[i];
				//          i++;
				j++;
				sum += array[j];
			}
			if (sum == 100)
				cout << '[' << i << ',' << j << ']';
		}
	}
*/
// ToDo Swift Code
var nums = [3, 6, 1, 7, 2]
func findInterval(sum: Int, array: [Int]) -> [(s: Int, e: Int)] {
	var ta = [(s: Int, e: Int)]()
	for i in 0..<array.count - 1 {
		var sum_t = array[i]
		if sum_t == sum {
			ta.append((i,i))
		}
		for j in (i + 1)..<array.count {
			sum_t += array[j]
			if sum_t == sum {
				ta.append((i,j))
			} else if sum_t > 10 {
				break
			}
		}
	}
	return ta
}
findInterval(10, array: nums)
/*:
	void find_interval(int array[], int n, int num) {
		int sum = 0;
		for (int i=0, j=0; j<=n; )  // 枚舉區間[i, j) {
			if (sum > num)
				sum -= array[i++];
			else
				sum += array[j++];
			if (sum == num)
				cout << '[' << i << ',' << j-1 << ']';
		}
	}
*/
// ToDo Swift Code
func find_interval(array: [Int], n: Int, num: Int) {
	var sum = 0
	for (var i = 0, j = 0; j<=n; ) {
		if sum > num {
			sum -= array[i++]
		} else {
			sum += array[j++]
		}
		if (sum == num) {
			print("[\(i),\(j - 1)]", separator: "", terminator: "\n")
		}
	}
}
find_interval(nums, n: 4, num: 10)
/*:
讀者可以想想看：陣列元素若有零、有負數，是否要調整枚舉方式？

[972]:http://uva.onlinejudge.org/external/9/972.html ""
[10464]:http://uva.onlinejudge.org/external/104/10464.html ""
[11536]:http://uva.onlinejudge.org/external/115/11536.html ""
[11572]:http://uva.onlinejudge.org/external/115/11572.html ""

_____________________
UVa [972], UVa [10464], UVa [11536], UVa [11572]
_____________________
## 範例：尋找陣列之中的最小值，陣列已經由小到大排序
_____________________
找到其中一個最小值：經常整理房間，尋找東西就快；預先排序資料，搜尋速度就快。

![](Enumeration13.png "")

	void find_minimum(){
		int array[5] = {3, 3, 6, 6, 9};
		cout << "最小的數字是" << array[0];
	}
*/
// ToDo Swift Code
var arrayX = [3, 3, 6, 6, 9]
let de = arrayX.sort { $0 > $1 }
let inc = arrayX.sort()
de
inc
/*:
找到所有最小值：讀者請自行嘗試。

## 範例：尋找陣列之中的特定數字，陣列已經由小到大排序
_____________________
找到其中一個特定數字：首先找到陣列中央的數字，依其數字大小，繼續搜尋左半段或者右半段。

![](Enumeration14.png "")

	void find_number() {
		int array[15] = {
				2, 3, 5, 7, 11,
				13, 17, 19, 23, 29,
				31, 37, 41, 43, 47
		};
		int left = 0, right = 15-1;
		while (left <= right) {
			int mid = (left + right) / 2;
			if (array[mid] < 29)
				left = mid + 1;     // 繼續搜尋剩下的右半段
			else if (array[mid] > 29)
				right = mid - 1;    // 繼續搜尋剩下的左半段
			else if (array[mid] == 29) {
				// 找到了其中一個數字
				cout << mid << ':' << array[mid];
				return;
			}
		}
		cout << "找不到29";
	}
*/
// ToDo Swift Code
var arrayXX = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
func find(num: Int, inArr: [Int]) -> Int? {
	var sorted = inArr.sort()
	var idxL = 0
	var idxR = sorted.count
	repeat {
		let mid = (idxL + idxR) / 2
		if sorted[mid] == num {
			return mid
		} else {
			if sorted[mid] > num {
				idxR = mid - 1
			} else {
				idxL = mid + 1
			}
		}
	} while idxL <= idxR
	return nil
}
find(47, inArr: arrayXX)
/*:
找到所有特定數字：讀者請自行嘗試。

## 範例：平面上距離最近的兩個點（ Closest Pair Problem ）
_____________________

![](Enumeration15.png "")

找到距離最近的其中一對點：預先依照 X 座標排序所有點，搜尋得以略過大量情況。

	struct Point {float x, y;};

	// 計算兩點之間的距離
	float dist(Point& a, Point& b) {
		float dx = a.x - b.x;
		float dy = a.y - b.y;
		return sqrt(dx * dx + dy * dy);
	}

	bool cmp(const Point& i, const Point& j) {
		return i.x < j.x;
	}

	void closest_pair() {
		Point point[10] = {
				{3, 3}, {1, 5}, {4, 6}, {2, 8}, {9, 9},
				{2, 1}, {7, 2}, {6, 5}, {9, 4}, {5, 9}
		};
		// 依照X座標排序所有點
		sort(point, point+10, cmp);
		float d = 1e9;
		for (int i=0; i<N; ++i)
			for (int j=i+1; j<N; ++j) {
				// 兩個點的X座標已經相距太遠，直接略過，
				// 繼續枚舉下一個左端點。
				if (p[j].x - p[i].x > d) break;
				d = min(d, dist(point[i], point[j]));
			}
		cout << "距離是" << d;
	}
*/
// ToDo Swift Code
//func distance(p1: [Int], p2: [Int]) -> Double {
//	let dx = p1[0] - p2[0]
//	let dy = p1[1] - p2[1]
//	return sqrt(Double(dx * dx + dy * dy))
//}
func closest_2(inPoints: [[Int]]) -> (pair: (p1: [Int], p2: [Int]), d: Double) {
	var sorted = inPoints.sort{ $0[0] < $1[0] }
	var p1: [Int] = [0, 0]
	var p2: [Int] = [0, 0]
	var d = Double(Int.max)
	for i in 0..<sorted.count - 1 {
		for j in (i + 1)..<sorted.count {
			if Double(sorted[j][0] - sorted[i][0]) > d { break }  //加速
			let dij = distance(sorted[i], p2: sorted[j])
			if dij < d {
				d = dij
				p1 = sorted[i]
				p2 = sorted[j]
			}
		}
	}
	return ((p1, p2), d)
}
closest_2(points).pair.p1
closest_2(points).pair.p2
closest_2(points).d
/*:
找到距離最近的每一對點：讀者請自行嘗試。

## 範例：英文單字從單數變複數
_____________________

枚舉各種情況，寫成大量判斷式。

![](Enumeration16.png "")

	void plural(string s) {
		int n = s.length();
		if (s.back() == 'y')
			cout << s.substr(0, n-1) << "ies";
		else if (s.back() == 's' || s.back() == 'x')
			cout << s << "es";
		else if (s.substr(n-2) == "sh" || s.substr(n-2) == "ch")
			cout << s << "es";
		else if (s.substr(n-3) == "man")
			cout << s.substr(0, n-3) << "men";
		else
			cout << s << 's';
	}
*/
// ToDo Swift Code   // *** 'hasPrefix' and 'hasSuffix' methods
func plural(s: String) -> String {
	var array = Array(s.characters)
	if s.hasSuffix("y") {
		array.removeLast()
		return String(array) + "ies"
	} else if s.hasSuffix("s") || s.hasSuffix("x") || s.hasSuffix("ch") || s.hasSuffix("sh") {
		return s + "es"
	} else if s.hasSuffix("man") {
		array.removeLast()
		array.removeLast()
		return String(array) + "en"
	} else {
		return s + "s"
	}
}
plural("Prefix")
/*:
## 範例：小畫家倒墨水（ Flood Fill Algorithm ）
_____________________
電腦圖片可以想成是一張方格紙，每個方格都填著一種顏色。現在要實現小畫家倒墨水的功能：以某一格為起點，只要相鄰方格顏色一樣，就染成同一個顏色。

![](Enumeration17.png "")

運用大量指令，枚舉上下左右四個方向；運用遞迴，枚舉相鄰同色方格。

必須避免已經枚舉過的方格又重複枚舉，否則程式在有生之年都不會結束。

	int image[10][10];  // 圖片的大小為 10x10

	void flood(int x, int y, int new_color, int old_color) {
		if (x>=0 && x<10 && y>=0 && y<10)   // 不能超出邊界
			if (image[x][y] == old_color)   // 同色方格才枚舉{
				// 染色
				image[x][y] = new_color;
				// 枚舉上下左右四個方向
				flood(x+1, y, new_color, old_color);
				flood(x-1, y, new_color, old_color);
				flood(x, y+1, new_color, old_color);
				flood(x, y-1, new_color, old_color);
			}
	}

	void ink() {
		// 在座標(7,6)的方格，淋上1號顏色。
		flood(7, 6, 1, image[7][6]);
	}
*/
// ToDo Swift Code
import UIKit
var subViews: [UIView] = [UIView]()
var view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
let c1 = UIColor.blueColor()
let c2 = UIColor.yellowColor()
for i in 0..<10 {
	for j in 0..<10 {
		let subView = UIView(frame: CGRect(x: i * 5, y: j * 5, width: 5, height: 5))
			subView.backgroundColor = rand() % 2 == 0 ? c1 : c2
		subViews.append(view)
		view.addSubview(subView)
	}
}
view
func flood(p: CGPoint, new_color: UIColor, old_color: UIColor) {
	let idx = Int(p.x * 10 + p.y)
	if (p.x >= 0 && p.x < 10 && p.y >= 0 && p.y < 10) {   // 不能超出邊界
		let subView = view.subviews[idx]
		if (subView.backgroundColor == old_color)   {// 同色方格才枚舉{
			// 染色
			subView.backgroundColor = new_color
			// 枚舉上下左右四個方向
			let nextL = CGPoint(x: p.x - 1, y: p.y)
			let nextR = CGPoint(x: p.x + 1, y: p.y)
			let nextU = CGPoint(x: p.x, y: p.y - 1)
			let nextD = CGPoint(x: p.x, y: p.y + 1)
			flood(nextL, new_color: new_color, old_color: old_color)
			flood(nextR, new_color: new_color, old_color: old_color)
			flood(nextU, new_color: new_color, old_color: old_color)
			flood(nextD, new_color: new_color, old_color: old_color)
		}
	}
}
flood(CGPoint(x: 3, y: 3), new_color: c1, old_color: c2)
view

/*:
大量指令，亦得寫成一個迴圈。

	void flood(int x, int y, int new_color, int old_color) {
		if (x>=0 && x<10 && y>=0 && y<10)
			if (image[x][y] == old_color) {
				image[x][y] = new_color;
				
				// 寫成一個迴圈
				for (int i=0; i<4; i++) {
					static int dx[4] = {1, -1, 0, 0};
					static int dy[4] = {0, 0, 1, -1};
					flood(x + dx[i], y + dy[i], new_color, old_color);
				}
			}
	}
*/
// ToDo Swift Code
func flood1(p: CGPoint, new_color: UIColor, old_color: UIColor) {
	let idx = Int(p.x * 10 + p.y)
	if (p.x >= 0 && p.x < 10 && p.y >= 0 && p.y < 10) {   // 不能超出邊界
		let subView = view.subviews[idx]
		if (subView.backgroundColor == old_color)   {// 同色方格才枚舉{
			// 染色
			subView.backgroundColor = new_color
			// 枚舉上下左右四個方向
			let a = [CGPoint(x: -1.0, y: 0.0), CGPoint(x: +1.0, y: 0.0), CGPoint(x: 0.0, y: -1.0), CGPoint(x: 0.0, y: +1.0)]
			for i in 0..<4 {
				let newP = CGPoint(x: p.x + a[i].x, y: p.y + a[i].y)
				flood(newP, new_color: new_color, old_color: old_color)
			}
		}
	}
}
flood1(CGPoint(x: 3, y: 9), new_color: c1, old_color: c2)
view

/*:
多層判斷式，亦得拆解成一層一層的判斷式。

	void flood(int x, int y, int new_color, int old_color) {
		if (!(x>=0 && x<10 && y>=0 && y<10)) return;
		if (image[x][y] != old_color) return;
		image[x][y] = new_color;
		for (int i=0; i<4; i++) {
			static int dx[4] = {1, -1, 0, 0};
			static int dy[4] = {0, 0, 1, -1};
			flood(x + dx[i], y + dy[i], new_color, old_color);
		}
	}
*/
// ToDo Swift Code
func flood2(p: CGPoint, new_color: UIColor, old_color: UIColor) {
	let idx = Int(p.x * 10 + p.y)
	if !(p.x >= 0 && p.x < 10 && p.y >= 0 && p.y < 10) { return }  // 不能超出邊界
	let subView = view.subviews[idx]
	if (subView.backgroundColor != old_color) { return }
	subView.backgroundColor = new_color
	let a = [CGPoint(x: -1.0, y: 0.0), CGPoint(x: +1.0, y: 0.0), CGPoint(x: 0.0, y: -1.0), CGPoint(x: 0.0, y: +1.0)]
	for i in 0..<4 {
		let newP = CGPoint(x: p.x + a[i].x, y: p.y + a[i].y)
		flood(newP, new_color: new_color, old_color: old_color)
	}
}
flood2(CGPoint(x: 8, y: 3), new_color: c1, old_color: c2)
view

/*:
[260]:http://uva.onlinejudge.org/external/2/260.html ""
[280]:http://uva.onlinejudge.org/external/2/280.html ""
[352]:http://uva.onlinejudge.org/external/3/352.html ""
[469]:http://uva.onlinejudge.org/external/4/469.html ""
[572]:http://uva.onlinejudge.org/external/5/572.html ""
[601]:http://uva.onlinejudge.org/external/6/601.html ""
[657]:http://uva.onlinejudge.org/external/6/657.html ""
[776]:http://uva.onlinejudge.org/external/7/776.html ""
[782]:http://uva.onlinejudge.org/external/7/782.html ""
[784]:http://uva.onlinejudge.org/external/7/784.html ""
[785]:http://uva.onlinejudge.org/external/7/785.html ""
[871]:http://uva.onlinejudge.org/external/8/871.html ""
[10267]:http://uva.onlinejudge.org/external/102/10267.html ""
[10336]:http://uva.onlinejudge.org/external/103/10336.html ""
[10946]:http://uva.onlinejudge.org/external/109/10946.html ""
[4792]:https://icpcarchive.ecs.baylor.edu/external/47/4792.pdf ""
[5130]:https://icpcarchive.ecs.baylor.edu/external/51/5130.pdf ""
[488]:http://uva.onlinejudge.org/external/4/488.html ""
[10055]:http://uva.onlinejudge.org/external/100/10055.html ""
[10370]:http://uva.onlinejudge.org/external/103/10370.html ""
[10878]:http://uva.onlinejudge.org/external/108/10878.html ""
[10929]:http://uva.onlinejudge.org/external/109/10929.html ""
[10167]:http://uva.onlinejudge.org/external/101/10167.html ""
[10125]:http://uva.onlinejudge.org/external/101/10125.html ""
[296]:http://uva.onlinejudge.org/external/2/296.html ""
[846]:http://uva.onlinejudge.org/external/8/846.html ""
[714]:http://uva.onlinejudge.org/external/7/714.html ""
_____________________
UVa [260], UVa [280], UVa [352], UVa [469], UVa [572], UVa [601]
UVa [657], UVa [776], UVa [782], UVa [784], UVa [785], UVa [871]
UVa [10267], UVa [10336], UVa [10946]
_____________________
ICPC [4792], ICPC [5130]
_____________________
## Straightforward Method / Trial and Error
_____________________
「直接法」，直接算出答案。例如按照流程進行得到答案、套用公式計算答案、直接印出答案。
_____________________
UVa [488], UVa [10055], UVa [10370], UVa [10878], UVa [10929]
_____________________
「嘗試錯誤法」、「試誤法」，針對答案進行 Enumerate 與 Search 。有些困難的問題，難以直接推導答案，既然推導不出來，就慢慢測試答案、慢慢驗算吧──確立答案的範圍，窮舉所有可能的答案，再從中搜尋正確答案。
_____________________
UVa [10167], UVa [10125], UVa [296], UVa [846], UVa [714]
_____________________
直接法和試誤法剛好相反。直接法是由題目本身下手，推導答案；試誤法則是從答案下手，讓答案迎合題目需求。

![](Enumeration18.png "")

## 範例：暴力攻擊（ Brute Force Attack ）
_____________________
破解密碼最簡單的方法叫做「暴力攻擊」。不知道密碼規律的情況下，無法直接推導正確密碼，只好以試誤法一一檢驗所有可能的密碼，從中找出正確密碼。

![](Enumeration19.png "")

## 範例：單向函數（ One-way Function ）
_____________________
「單向函數」是一種特別的函數，給定輸入很容易算出輸出，但是給定輸出卻很難算出輸入。

![](Enumeration20.png "")

舉例來說，令一個函數的輸入是兩個質數，輸出是兩個質數的乘積。給定兩個質數可以輕易的在多項式時間內算出乘積，然而給定兩質數的乘積卻需要指數時間才能完成質因數分解。

如果給定一個單向函數的輸入，求其輸出，就適合用直接法，套用函數快速算得答案；如果給定一個單向函數的輸出，求其輸入，就適合用試誤法，嘗試各種輸入並套用函數快速驗證答案。
_____________________
[Next](@next)
*/
