import UIKit




var a = Array2D(rows: 3, columns: 5, initialValue: 0)
for i in a.rowIndices {
	for j in a.colIndices {
		a[i,j] = i*a.columns + j
	}
}

let colIndices = a.colIndices
let rowIndices = a.rowIndices
let b = a[1,2...4]

a[0..<3,2]

zip(colIndices, a[0,nil])
zip(rowIndices, a[nil,0])

var xxxx = ["1",2,3]
xxxx.visualizeView()
xxxx.visualizeView(index: 2)
visualize(xxxx, index: 1)
visualize(a)
visualize(a, col: 3)
visualize(a, row: 1)
a.visualizeView(column: 4)

let str = "I am a superman."
str.visualizeView(7...14)

let v1 = Vector2D(x: 3, y: 2)
v1.visualizeView()


