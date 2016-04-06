/*:
[Previous](@previous) | 本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#3) | [Next](@next)
****
# Enumerate Combinations
## Combination （ Subset ）
****
便是數學課本中「排列組合」的「組合」；概念等於「子集合」。但是這裡不是要計算組合有多少種，而是枚舉所有的組合，以字典順序枚舉。

例如 {1,2,3} 所有的組合就是 {} 、 {1} 、 {2} 、 {3} 、 {1,2} 、 {1,3} 、 {2,3} 、 {1,2,3} 。
	
## 範例：枚舉 {0,1,2,3,4} 所有組合
****
該如何枚舉呢？先觀察平時我們計算組合個數的方法。
	
	{0,1,2,3,4} 所有組合個數總共 2^5 個： 0 可取可不取，有兩種情形、 1 可取可不取，有兩種情形、 ... 、 4 可取可不取，有兩種情形。根據乘法原理，總共 2*2*2*2*2 = 2^5 種情形。

枚舉方式可以仿照乘法原理。建立一個陣列，當作一個集合。 solution[i] = true 表示這個集合擁有第 i 個元素，觀念等同「Set資料結構：索引儲存(http://www.csie.ntnu.edu.tw/~u91029/Set.html)」。

依序枚舉每個位置。針對每個位置，試著填入取或不取。

![](Backtracking4.png "")

	bool solution[5];   // 索引儲存
	void backtrack(int n) {
		// it's a solution
		if (n == 5) {
			for (int i=0; i<5; i++)
			if (solution[i])
			cout << i << ' ';
			cout << endl;
			return;
		}
		// 選取數字n，然後繼續枚舉之後的位置。
		solution[n] = true;
		backtrack(n+1);
		// 不取數字n，然後繼續枚舉之後的位置。
		solution[n] = false;
		backtrack(n+1);
	}
	void enumerate_combinations() {
			backtrack(0);
	}

亦得改用其他資料結構，例如「Set資料結構：循序儲存(http://www.csie.ntnu.edu.tw/~u91029/Set.html)」。

![](Backtracking5.png "")

	int subset[5];  // 循序儲存
	void backtrack(int n, int size) { // size為子集合大小
		// it's a solution
		if (n == 5) {
			// print solution
			for (int i=0; i<size; i++)
			cout << subset[i] << ' ';
			cout << endl;
			return;
		}
		// 選取數字n，然後繼續枚舉剩下的數字。
		subset[size] = n;
		backtrack(n+1, size+1);
		// 不取數字n，然後繼續枚舉剩下的數字。
		backtrack(n+1, size);
	}

	void enumerate_combinations() {
			backtrack(0, 0);
	}

## 範例：枚舉 {0,1,2,3,4} 所有組合
****
依序枚舉每個選取。針對每個選取，試著填入各個位置。

![](Backtracking6.png "")

	bool solution[5];   // 索引儲存
	void backtrack(int n) {
		// print_solution
		for (int i=0; i<5; i++)
		if (solution[i])
		cout << i << ' ';
		cout << endl;
		for (; n<5; ++n){
			// 選取數字n
			solution[n] = true;
			// 然後繼續枚舉後面的數字
			backtrack(n+1);
			// 回復原狀
			solution[n] = false;
		}
	}
	void enumerate_combinations() {
			backtrack(0);
	}

![](Backtracking7.png "")

	int subset[5];  // 循序儲存
	void backtrack(int n, int size) {  // size為子集合大小
		// print_solution
		for (int i=0; i<size; i++)
		cout << subset[i] << ' ';
		cout << endl;
		for (; n<5; ++n) {
			// 選取數字n
			subset[size] = n;
			// 然後繼續枚舉後面的數字
			backtrack(n+1, size+1);
			// 不必特地回復原狀，數字n會覆蓋過去。
		}
	}
	void enumerate_combinations() {
			backtrack(0, 0);
	}

## 範例：枚舉 {6,7,13,4,2} 所有組合
****
預先排序數字，輸出結果就會照字典順序排列。


	int array[5] = {6, 7, 13, 4, 2};
	int subset[5];  // 循序儲存
	void backtrack(int n, int size) { // size為子集合大小
		// it's a solution
		if (n == 5) {
			print_solution();
			return;
		}
		// 選取數字array[n]，然後繼續枚舉剩下的數字。
		subset[size] = array[n];
		backtrack(n+1, size+1);
		// 不取數字array[n]，然後繼續枚舉剩下的數字。
		backtrack(n+1, size);
	}
	void enumerate_combinations() {
			sort(array, array+5);
			backtrack(0, 0);
	}

****

	int array[5] = {6, 7, 13, 4, 2};
	int subset[5];  // 循序儲存
	void backtrack(int n, int size) { // size為子集合大小
		print_solution();
		for (; n<5; ++n) {
			// 選取數字array[n]
			subset[size] = array[n];
			// 然後繼續枚舉剩下的數字
			backtrack(n+1, size+1);
		}
	}

	void enumerate_combinations() {
			sort(array, array+5);
			backtrack(0, 0);
	}

****
[Previous](@previous) | 本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#3) | [Next](@next)
*/
