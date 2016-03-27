/*:
[Previous](@previous)
_____________________
# Parallel Algorithm
（ Under Construction! ）
### 眾心成城，眾口鑠金。《國語》
_____________________
## Parallel Algorithm

「循序計算 Sequential Computing 」就是逐一計算，「平行計算 Parallel Computing 」就是一齊計算，兩者是相對的概念。

「平行化」。當計算順序無所謂時，就可以使用多個計算器一齊計算。優點是減少計算時間，缺點是增加硬體、增加電力。


詳細架構是：一份記憶體，多個計算器。一份記憶體一齊傳遞資料給各個計算器，多個計算器一齊計算，多個計算器一齊傳遞資料給一份記憶體。

計算器又有兩種類型：多個計算器只能一齊執行相同指令（例如 GPU ），多個計算器可以分頭執行不同指令（例如多核心處理器）。前者富含巧思，後者缺乏變化，所以我們只談前者。


## 範例：複製字串
_____________________
理論：各個字元分頭複製，時間複雜度從 O(N) 變 O(1) 。

實務：字串切成數段，分頭複製。



	void copy() {
		char s[15] = "incremental";
		char t[15];
		int i;
		#pragma omp parallel for
		for (i=0; s[i]; ++i)
			t[i] = s[i];
		t[i] = '\0';
		cout << "原本字串" << s;
		cout << "複製之後的字串" << t;
	}
*/
// ToDo Swift Code
/*:
因為作業系統建立執行緒需要大量時間與空間，所以平行計算不一定比循序計算好。程式員必須自行取捨。

## 範例：加總數字
_____________________
理論：數字雙雙相加，時間複雜度從 O(N) 變 O(logN) 。
	
	
實務：陣列切成數段，分頭計算總和。最後累加各段總和。



	void summation() {
			int array[5] = {3, 6, 9, -8, 1};
			// 陣列切成兩段，分頭計算總和。
			int sum = 0;
			#pragma omp parallel for num_thread(2) schedule(static) reduction(+:sum)
			for (int i=0; i<5; i++)
				sum = sum + array[i];
			cout << "總和是" << sum;
	}
*/
// ToDo Swift Code
/*:
## 範例：矩陣相乘
_____________________
理論：兩層的平行化，外層是乘積矩陣的每一個元素，內層是兩串數列點對點相乘，時間複雜度從 O(N^3) 變 O(1) 。
	
實務：執行緒數量高達 O(N^3) ，不但跟循序計算沒兩樣，而且還得額外浪費設置執行緒的時間與空間，弄巧成拙、過猶不及。大家習慣放棄數列相乘的平行化。



	void matrix_multiply(float A[N*N], float B[N*N], float C[N*N]) {
		int i, j, k;
		#pragma omp parallel for collapse(2) private(k)
		for (i=0; i<N; i++)
			for (j=0; j<N; j++) {
			// 放棄數列相乘的平行化
				for (k=0; k<N; k++)
					C[N*i+j] += A[N*i+k] * B[N*k+j];
			}
	}
*/
// ToDo Swift Code
/*:
相同資料重複傳遞很多份到各個執行緒，改為每次計算一塊區域。



	const int int N, P, M;  // matrix dimensions
	float A[N*P], B[P*M], C[N*M];
	int NB = 0;             // number of blocks
	int Nb = N / NB;        // block dimensions
	int Pb = P / NB;
	int Mb = M / NB;

	void clear_block(float* C, int gapC, int Nb, int Mb) {
		for (int i=0; i<Nb; ++i)
			for (int j=0; j<Mb; ++j)
				// C[i][j] = 0;
				C[i * gapC + j] = 0.0;
	}

	void multiply_block(float* A, float* B, float* C, int gapA, int gapB, int gapC) {
		for (int i=0; i<N; ++i)
			for (int j=0; j<M; ++j) {
				// C[i][j] += A[i][k] * B[k][j];
				float t = C[i*gapC + j];
				for (int k=0; k< P; ++k)
					t += A[i*gapA + k] * B[k*gapB + j];
				C[i*gapC + j] = t;
		}
	}

	void matrix_multiply() {
		int ib, jb, kb;
		#pragma omp parallel for private(jb,kb) schedule(static)
		for (ib=0; ib<NB; ++ib)
			for (jb=0; jb<NB; ++jb) {
				// Cb[ib][jb] = 0;
				float* ptrC = C + ib * Nb * M + jb * Mb;
				clear_block(ptrC, M, Nb, Mb);
				// Cb[ib][jb] = Ab[ib][kb] * Bb[kb][jb];
				for (kb=0; kb<NB; ++kb)
					multiply_block(
						A + ib * Nb * P + kb * Pb,
						B + kb * Pb * M + jb * Mb,
						ptrC,
						P, M, M
				);
		}
	}
*/
// ToDo Swift Code
/*:
## 範例：生命遊戲
_____________________
理論：兩層的平行化，外層是地圖的每一個細胞，內層是八個鄰居細胞數量總和，時間複雜度從 O(XY * 8) 變 O(log8) 。
	
實務：大家習慣放棄放棄平行化細胞求和。


## 範例： Hamilton Path
_____________________
理論：如果能夠建立 N! 個執行緒，時間複雜度就從 O(N!) 變 O(N) ──可是要去哪裡生那麼多個執行緒？即便是平行化也無法快速解決 NP-Complete 問題。


## 範例： branch overhead
_____________________
[Next](@next)
*/
