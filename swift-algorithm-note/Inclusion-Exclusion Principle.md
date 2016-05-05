[Previous](0_1 Knapsack Problem.md) | 回到[目錄](Modeling.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#7) | [Next](Appendix - Web.md)
_____________________
# Inclusion-Exclusion Principle
## 排容原理

類似於枚舉所有子集合，但是每個子集合有正負號之別──奇數個集合的交集為正號、偶數個集合的交集為負號。

舉例：求出 1 到 100 當中不可被 3 或 5 或 8 整除的整數有幾個。 3 、 5 、 8 均兩兩互質。

	int array[3] = {3, 5, 8};
	// 排容，sign為正負號，divisor為各種可能的除數
	int backtrack(int n, int sign, int divisor) {
		// it's a solution
		if (n == 3) return sign * (100 / divisor);
		int total = 0;
		// 不選。正負號維持不變，除數維持不變。
		// solution[n] = false;
		total += backtrack(n+1, sign, divisor);
		// 選。須變號，並逐步累計除數。
		// 因逐步累計除數，故不需要具體記錄選到的數字
		// solution[n] = true;
		total += backtrack(n+1, -sign, divisor * array[n]);
		return total;
	}
	void inclusion_exclusion() {
		cout << "1到100當中不可被3或5或8整除的整數";
		cout << "有" << backtrack(0, +1, 1) << "個";
	}

考慮數字之間不互質的一般情形：

	int array[5] = {3, 5, 6, 7, 9};
	// 最大公因數
	int gcd(int a, int b){
		return b ? gcd(b, a%b) : a;
	}
	// 最小公倍數
	int lcm(int a, int b) {
		return a / gcd(a, b) * b;
	}
	// 精簡過後的排容程式碼，divisor為各種可能的除數
	int backtrack(int n, int divisor) {
		if (n == 5) return 100 / divisor;
		return backtrack(n+1, divisor)
			- backtrack(n+1, lcm(divisor, array[n]));
	}
	void inclusion_exclusion() {
		cout << "1到100當中不可被3或5或6或7或9整除的整數";
		cout << "有" << backtrack(0, 1) << "個";
	}

枚舉子集合（組合）有兩種枚舉方式，排容原理亦有兩種枚舉方式。

	int array[5] = {3, 5, 6, 7, 9};
	int backtrack(int n, int divisor) {
		int total = 0;
		total += 100 / divisor; // 目前湊出來的集合
		// 繼續枚舉之後的數字，記得變號
		for (int i=n; i<5; ++i)
		total -= backtrack(i+1, lcm(divisor, array[i]));
		return total;
	}
	void inclusion_exclusion() {
		cout << "1到100當中不可被3或5或6或7或9整除的整數";
		cout << "有" << backtrack(0, 1) << "個";
	}

_____________________
UVa [10325](http://uva.onlinejudge.org/external/103/10325.html)
_____________________
[Previous](0_1 Knapsack Problem.md) | 回到[目錄](Modeling.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#7) | [Next](Appendix - Web.md)
