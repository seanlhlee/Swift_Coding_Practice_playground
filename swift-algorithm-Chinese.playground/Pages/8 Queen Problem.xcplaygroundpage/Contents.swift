/*:
[Previous](@previous) | 本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#4) | [Next](@next)
****
# 8 Queen Problem
## 八皇后問題

問題：在 8x8 的西洋棋棋盤上擺放八隻皇后，讓他們恰好無法互相攻擊對方。

一個非常簡單的想法：每一格都有「放」和「不放」兩種選擇，枚舉所有可能，並避免枚舉出皇后互相攻擊的情形。建立 8x8 的 bool 陣列，代表一個 8x8 的棋盤盤面情形。例如 solution[0][0] = true 表示 (0,0) 這個位置有放置皇后。

	bool solution[8][8];
	void backtrack(int x, int y) {
		if (y == 8) x++, y = 0; // 換到下一排格子
		// it's a solution
		if (x == 8) {
			print_solution();
			return;
		}
		// 放置皇后
		solution[x][y] = true;
		backtrack(x, y+1);
		// 不放置皇后
		solution[x][y] = false;
		backtrack(x, y+1);
	}
	void eight_queen() {
			backtrack(0, 0);
	}

接著要避免枚舉出不可能出現的答案：任一直線、橫線、左右斜線上面只能有一隻皇后。分別建立四個 bool 陣列，紀錄皇后在各條線上擺放的情形，這個手法很常見，請見程式碼。

	bool solution[8][8];
	bool mx[8], my[8], md1[15], md2[15];    // 初始值都是 false
	void backtrack(int x, int y) {
		if (y == 8) x++, y = 0; // 換到下一排格子
		// it's a solution
		if (x == 8) {
			print_solution();
			return;
		}
		// 放置皇后
		int d1 = (x+y) % 15, d2 = (x-y+15) % 15;
		if (!mx[x] && !my[y] && !md1[d1] && !md2[d2]) {
			// 這隻皇后佔據了四條線，記得標記起來。
			mx[x] = my[y] = md1[d1] = md2[d2] = true;
			solution[x][y] = true;
			backtrack(x, y+1);
			// 遞迴結束，回復到原本的樣子，要記得取消標記。
			mx[x] = my[y] = md1[d1] = md2[d2] = false;
		}
		// 不放置皇后
		solution[x][y] = false;
		backtrack(x, y+1);
	}
	void eight_queen() {
		backtrack(0, 0);
	}

以及避免枚舉出不可能出現的答案：最終的棋盤上面不足八隻皇后。

	bool solution[8][8];
	bool mx[8], my[8], md1[15], md2[15];    // 初始值都是 false
	void backtrack(int x, int y, int c) {
		if (y == 8) x++, y = 0; // 換到下一排格子
		// it's a solution
		if (x == 8) {
			if (c != 8) return; // 不是八隻皇后就避免枚舉答案
			print_solution();
			return;
		}
		// 放置皇后
		int d1 = (x+y) % 15, d2 = (x-y+15) % 15;
		if (!mx[x] && !my[y] && !md1[d1] && !md2[d2]) {
			mx[x] = my[y] = md1[d1] = md2[d2] = true;
			solution[x][y] = true;
			backtrack(x, y+1, c+1); // 皇后多一隻
			mx[x] = my[y] = md1[d1] = md2[d2] = false;
		}
		// 不放置皇后
		solution[x][y] = false;
		backtrack(x, y+1, c);       // 皇后和原來一樣多
	}
	void eight_queen() {
			backtrack(0, 0, 0); // 一開始棋盤是空的，皇后數目為零。
	}

改進

由於一條線必須剛好擺放一隻皇后，故可以以線為單位來遞迴窮舉。重新建立一條一維 int 陣列， solution[0] = 5 表示第零個直行上的皇后，擺在第五個位置。

	int solution[8];
	void backtrack(int x) // 每次都換一排格子 {
		// it's a solution
		if (x == 8) {
			print_solution();
			return;
		}
		// 分別放置皇后在每一格，並各自遞迴下去。
		solution[x] = 0;
		backtrack(x+1);
		solution[x] = 1;
		backtrack(x+1);
		......
		solution[x] = 7;
		backtrack(x+1);
	}

縮成迴圈是一定要的啦！

	int solution[8];
	void backtrack(int x) {  // 每次都換一排格子
		// it's a solution
		if (x == 8) {
			print_solution();
			return;
		}
		// 分別放置皇后在每一格，並各自遞迴下去。
		for (int y=0; y<8; ++y) {
			solution[x] = y;
			backtrack(x+1);
		}
	}

接著要避免枚舉出不可能出現的答案。

	int solution[8];
	bool my[8], md1[15], md2[15];   // 初始值都是 false
	// x這條線可以不用檢查了
	void backtrack(int x) {  // 每次都換一排格子
		// it's a solution
		if (x == 8) {
			print_solution();
			return;
		}
		// 分別放置皇后在每一格，並各自遞迴下去。
		for (int y=0; y<8; ++y) {
			int d1 = (x+y) % 15, d2 = (x-y+15) % 15;
			if (!my[y] && !md1[d1] && !md2[d2]) {
				// 這隻皇后佔據了四條線，記得標記起來。
				my[y] = md1[d1] = md2[d2] = true;
				solution[x] = y;
				backtrack(x+1);
				// 遞迴結束，回復到原本的樣子，要記得取消標記。
				my[y] = md1[d1] = md2[d2] = false;
			}
		}
	}

改進

8 Queen Problem 的答案是上下、左右、對角線對稱的。排除對稱的情形，可以節省枚舉的時間。這裡不加贅述。

另一種左右斜線判斷方式

比用陣列紀錄還麻煩。自行斟酌。

	void backtrack(int x) }  // 每次都換一排格子
		for (int i=0; i<x; ++i)
		if (abs(x - i) == abs(solution[x] - solution[i]))
		return;
		......
	}

UVa [167](http://uva.onlinejudge.org/external/1/167.html) [750](http://uva.onlinejudge.org/external/7/750.html) [10513](http://uva.onlinejudge.org/external/105/10513.html) [639](http://uva.onlinejudge.org/external/6/639.html) [989](http://uva.onlinejudge.org/external/9/989.html) [10893](http://uva.onlinejudge.org/external/108/10893.html) [10957](http://uva.onlinejudge.org/external/109/10957.html)

****
[Previous](@previous) | 本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/Backtracking.html#4) | [Next](@next)
*/
