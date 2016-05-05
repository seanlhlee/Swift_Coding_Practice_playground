[Previous](Scaling Method.md) | 回到[目錄](SUMMARY.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/AlgorithmDesign.html#10) | [Next](Parallel Algorithm.md)
_____________________
# External Memory Algorithm
（ Under Construction! ）
### 士農工商四民者，國之石，民也。
### 不可使雜處，雜處則其言哤，其事亂。《管子》
_____________________
## Streaming Algorithm
## 範例：緩衝區（ Buffer ）
_____________________
## 範例：選擇排序法暨二分搜尋法（ Selection Sort + Binary Search ）
_____________________
檔案太大，記憶體不足，只好屢次從檔案裡面取得一部分數字。由於沒有其他暫存區，只好取得最小的數字，即時輸出結果。

篩選最小的數字、排序、輸出。活用二分搜尋法，調控篩選範圍，符合記憶體容量。

小心處理同一數字數量非常多的情況。


	int MIN = -1000000000;  // 數字的最小值
	int MAX = 1000000000;   // 數字的最大值
	const int N = (1 << 19);
	const int M = (1 << 18);
	int memory[N];          // 記憶體（內存）
	int buffer[M];          // 緩衝區（緩存）

	// 讀取檔案裡面所有數字，篩選大於等於L、小於等於R的數字。
	int read(ifstream& fin, int L, int R) {
		int n = 0;
		fin.clear();            // 回復讀寫狀態
		fin.seekg(0, fin.beg);  // 回到檔案開頭
		while (true) {
			// 讀取檔案裡面的數字
			fin.read((char*)buffer, sizeof(int)*M);
			int c = fin.gcount() / sizeof(int);
			if (c <= 0) break;  // 沒有數字就結束
			// 篩選數字，儲存至記憶體。
			for (int i = 0; i < c; i++)
				if (buffer[i] >= L && buffer[i] <= R)
					if (L == R) {
						if (n < N) memory[n++] = buffer[i];
						else n++;   // 同一數字出現許多次
					} else {
						if (n < N) memory[n++] = buffer[i];
						else return -1; // 存不下
					}
		}
		return n;
	}

	// 選擇排序法
	// 屢次從檔案裡面篩選最小的數字們。排序。輸出。
	// 如果記憶體裝不下，把數值範圍變一半，重做一遍。
	void sort_file() {
		ifstream fin("number.in", ios::binary);
		ofstream fout("number.out", ios::binary);
		// 二分搜尋法
		for (int L = MIN, R = MAX; L <= R; ) {
			int M = (L + R) / 2;
			int n = read(fin, L, M);
			if (n < 0)          // 記憶體不足。縮小篩選範圍。
				R = M;
			else if (n == 0)    // 處理其餘範圍
				L = M + 1;
			else {              // 記憶體充足。排序。輸出。
				if (L == M) {
					for ( ; n > N; n -= N)
						fout.write((char*)memory, sizeof(int)*N);
					if (n > 0)
						fout.write((char*)memory, sizeof(int)*n);
				} else {
					sort(memory, memory + n);
					fout.write((char*)memory, sizeof(int)*n);
				}
				// 處理其餘範圍
				L = M + 1;
				R = MAX;
			}
		}
		fin.close();
		fout.close();
	}
*/
// ToDo Swift Code
/*:
## Cache-oblivious Algorithm
_____________________
儲存容量大，存取時間長；儲存容量小，存取時間短。魚與熊掌不可兼得。自然而然形成階層式架構：硬碟、記憶體、快取、暫存器，儲存容量越來越小，存取時間越來越短。

進行計算的變數，儲存在暫存器；暫存器沒有，就找快取；快取沒有，就找記憶體；記憶體沒有，就找硬碟。

	_______________________________
	cpu cache		256KB
	main memory		512MB - 1024MB
	disk			20GB - 120GB
	_______________________________

對中央處理器來說，最花時間的不是運算，而是從記憶體載入資料到快取。調整資料結構、調整計算順序，避免頻繁載入資料。

## 範例：陣列與串列
_____________________
陣列在記憶體是連續的。串列在記憶體通常不是連續的。

循序枚舉，陣列偶爾載入區塊，串列時常載入區塊。


## 範例：生命遊戲
_____________________
區塊循序銜接成為一維陣列。一維陣列循序銜接成為二維陣列。


生命遊戲有數個回合，一個回合枚舉每個位置，一個位置枚舉八個方向。上下方向通常是不同區塊，左右方向通常是相同區塊。

區塊從長條改成方塊，減少載入次數。


## External Memory Algorithm
_____________________
快取的儲存容量不敷使用，必須在快取與記憶體之間來回搬移資料，不得不浪費大量時間。

「外部記憶體演算法」是假設輸入資料放在外部記憶體（例如硬碟、光碟、隨身碟），必須從外部記憶體讀取資料至快取，將通道大小、快取大小納入考慮的演算法。

「快取無視演算法」採用相同假設，而通道大小、快取大小為定值，僅考慮存取次數。這也是將記憶體架構納入考慮的演算法，雖然名稱上完全不是那麼回事。

## 範例：合併排序法（ Merge Sort ）
_____________________
如果必須直接輸出答案，每次都要讀檔掃描所有數字，抓出最小的那些數字。

如果有檔案可以暫存計算結果，考慮存取次數。

讀取 n/ram size + n/input buffer size + n/output buffer size 次。

ram size = input buffer size * k + output buffer size

## 範例：桶子排序法（ Bucket Sort ）
_____________________

[桶子排序法]:http://stackoverflow.com/questions/7153659/ ""

[桶子排序法]
_____________________
[Previous](Scaling Method.md) | 回到[目錄](SUMMARY.md) |本文來源: [演算法筆記](http://www.csie.ntnu.edu.tw/~u91029/AlgorithmDesign.html#10) | [Next](Parallel Algorithm.md)
