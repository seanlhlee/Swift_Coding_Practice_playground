/*:
[Previous](@previous)
_____________________
# 大量 Data 資料結構 :
### Array / List
_____________________
## Array

![](Data1.png "")

繁中「陣列」，簡中「数组」。連續的記憶體。

一個格子放入一筆資料，資料可以是一個數字、一個字元（所有字元合起來變成字串）、一個物件等等。

搜尋、插入、刪除的時間複雜度都是 O(N) 。資料已排序，則支援二分搜尋。

可以直接使用 STL 的 vector 。

[10370]:http://uva.onlinejudge.org/external/103/10370.html ""
[11991]:http://uva.onlinejudge.org/external/119/11991.html ""
[11716]:http://uva.onlinejudge.org/external/117/11716.html ""

_____________________
UVa [10370], UVa [11991], UVa [11716]
_____________________
## List （ Linked List ）
_____________________

![](Data2.png "")

繁中「串列」，簡中「链表」。藉由指標得到下一塊記憶體。

搜尋的時間複雜度是 O(N) 。知道正確位置，插入與刪除的時間複雜度是 O(1) ，否則必須先搜尋。無索引值，故不支援二分搜尋。

可以直接使用 STL 的 list 。

![](Data3.png "")

深究串列，其實串列是用陣列實作。一步一步釐清：

上圖：藉由指標得到下一塊記憶體。

中圖：指標是一個變數，儲存記憶體位址。

下圖：電腦記憶體是一條很長的陣列，串列其實是散落在陣列裡面。另外還需要一個變數紀錄串列的開頭，不過這邊沒畫上去。

## 特殊的 List
_____________________

![](Data4.png "")

尾串到頭，頭尾循環，稱作 Circular List 。特色是開頭可以隨便選、隨便動。

![](Data5.png "")

只串單向，稱作 Singly Linked List 。雙向都串，稱作 Doubly Linked List ，特色是雙向都能搜尋。

Doubly Linked List 若用 XOR 實作，稱作 XOR Linked List 。

Doubly Linked List 若可以還原刪除動作，稱作 Dancing Links ，經常配合 Backtracking 一起使用。

[11988]:http://uva.onlinejudge.org/external/119/11988.html ""
[2659]:https://icpcarchive.ecs.baylor.edu/external/26/2659.pdf ""

_____________________
UVa [11988], ICPC [2659]
_____________________
List 裡面放入 Array
_____________________

![](Data6.png "")

英文網路稱做 Unrolled Linked List ，中文網路稱作「鬆散鏈表」、「塊狀鏈表」。查無正式學術名稱。

N 筆資料，分成 A 塊，每塊約 B = N/A 個元素。每塊各自紀錄元素數量。

索引：先數塊、再數元素，時間複雜度為 O(A) 。

搜尋：全找，時間複雜度為 O(N) 。資料已排序，則為 O(A + logB) 。

插入、刪除：一塊大於等於 2B 就拆開成兩塊，相鄰兩塊小於等於 B 就合併成一塊，避免一拆開就要合併、一合併就要拆開，時間複雜度為 O(A + 2B) 到 O(2A + B) 。

N 筆資料，分成 A = sqrtN 塊，每塊約 B = sqrtN 個元素，是最均衡的，可令時間複雜度最低。索引、插入、刪除的時間複雜度為 O(sqrtN) 。競賽選手稱此技巧為 sqrt decomposition 。

上古時代的文字編輯器曾使用此資料結構。

## Array 裡面放入 List
_____________________

![](Data7.png "")

大致上就是圖論的 Adjacency Lists 。

大致上就是之後提到的 Hash Table 。
_____________________
[Next](@next)
*/
