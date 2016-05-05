[Previous](Euclidean Shortest Path.md) | 回到[目錄](Modeling.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#6) | [Next](Inclusion-Exclusion Principle.md)
_____________________
# 0/1 Knapsack Problem
## 0/1 背包問題

問題：一群各式各樣的物品，重量與價值皆不同。一個背包，有耐重限制。現在要將物品儘量塞進背包裡，令背包裡物品總價值最高。

一個簡單的想法：每個物品都有「要」和「不要」兩種選擇，窮舉所有可能，並避免枚舉出背包超載的情形。建立一維 bool 陣列， solution[0] = true 表示第零個物品有放進背包。

	bool solution[10];  // 十個物品
	int weight[10] = {4, 54, 1, ..., 32};   // 十個物品分別的重量
	int cost[10] = {3, 3, 11, ..., 23};     // 十個物品分別的價值
	const int maxW = 100;   // 背包承載上限
	int maxC = 0;           // 出現過的最高總值
	void backtrack(int n, int w, int c) {
		// it's a solution
		if (n == 10) {
			if (c > maxC) {  // 紀錄總值最高的
				maxC = c;
				store_solution();
			}
			return;
		}
		// 放進背包
		if (w + weight[n] <= maxW) { // 檢查背包超載
			solution[n] = true;
			backtrack(n+1, w + weight[n], c + cost[n]);
		}
		// 不放進背包
		solution[n] = false;
		backtrack(n+1, w, c);
	}
	bool answer[10];    // 正確答案
	void store_solution() {
			for (int i=0; i<10; ++i)
			answer[i] = solution[i];
	}

檢查背包超載的部分可以修改成更美觀的樣子。

	void backtrack(int n, int w, int c) {
		if (w > maxW) return;   // 背包超載
		// it's a solution
		if (n == 10) {
			if (c > maxC) {  // 紀錄總值最高的
				maxC = c;
				store_solution();
			}
			return;
		}
		// 放進背包
		solution[n] = true;
		backtrack(n+1, w + weight[n], c + cost[n]);
		// 不放進背包
		solution[n] = false;
		backtrack(n+1, w, c);
	}

各位可以預先排序物品重量，再執行 backtracking 程式碼，看看效率有何不同。然後嘗試使用 heuristic bound 加快速度。

_____________________
[Previous](Euclidean Shortest Path.md) | 回到[目錄](Modeling.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#6) | [Next](Inclusion-Exclusion Principle.md)