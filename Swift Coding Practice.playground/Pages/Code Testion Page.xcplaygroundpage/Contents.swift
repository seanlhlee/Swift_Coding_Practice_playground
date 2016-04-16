/*: 
[Previous](@previous)
****
*/
import Foundation

/**
* Created by joonkukang on 2014. 1. 12..
*/
//m = module.exports;

func randn() -> Double {
	// generate random guassian distribution number. (mean : 0, standard deviation : 1)
	var v1, v2, s: Double
	repeat {
		v1 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
		v2 = 2.0 * arc4random().toDouble() / UInt32.max.toDouble() - 1.0   // -1.0 ~ 1.0
		s = v1 * v1 + v2 * v2
	} while (s >= 1.0 || s == 0.0)
	
	s = sqrt( (-2.0 * log(s)) / s )
	return v1 * s
}

func shape<T: Computable>(matrix: [[T]]) -> [Int] {
	return [matrix.count, matrix[0].count]
}

func addVec(vector1: [Double], vector2: [Double]) -> [Double]? {
	guard vector1.count == vector2.count else { return nil }
	var array = vector1
	for i in 0..<array.count {
		array[i] = vector1[i] + vector2[i]
	}
	return array
}

func minusVec(vector1: [Double], vector2: [Double]) -> [Double]? {
	guard vector1.count == vector2.count else { return nil }
	var array = vector1
	for i in 0..<array.count {
		array[i] = vector1[i] - vector2[i]
	}
	return array
}

func addMatScalar(matrix: [[Double]], scalar: Double) -> [[Double]] {
	let row = shape(matrix)[0]
	let col = shape(matrix)[1]
	var result = [[Double]]()
	for i in 0..<row {
		var rowVec = [Double]()
		for j in 0..<col {
			rowVec.append(matrix[i][j] + scalar)
		}
		result.append(rowVec)
	}
	return result
}

func addMatVec(matrix: [[Double]], vector: [Double]) -> [[Double]]? {
	guard !matrix.isEmpty && !vector.isEmpty else { return nil }
	guard matrix[0].count == vector.count else { return nil }
	return matrix.map{ addVec($0, vector2: vector)! }
}

func minusMatVec(matrix: [[Double]], vector: [Double]) -> [[Double]]? {
	guard !matrix.isEmpty && !vector.isEmpty else { return nil }
	guard matrix[0].count == vector.count else { return nil }
	return matrix.map{ minusVec($0, vector2: vector)! }
}

func addMat(matrixA a: [[Double]], matrixB b: [[Double]]) -> [[Double]]? {
	guard !a.isEmpty && !b.isEmpty else { return nil }
	guard a.count == b.count else { return nil }
	let row = [Double](count: a[0].count, repeatedValue: a[0][0])
	var matrix = [[Double]](count: a.count, repeatedValue: row)
	for i in 0..<a.count {
		if a[i].count != b[i].count {
			return nil
		}
		for j in 0..<matrix[i].count {
			matrix[i][j] = a[i][j] + b[i][j]
		}
	}
	return matrix
}

func minusMat(matrixA a: [[Double]], matrixB b: [[Double]]) -> [[Double]]? {
	guard !a.isEmpty && !b.isEmpty else { return nil }
	guard a.count == b.count else { return nil }
	let row = [Double](count: a[0].count, repeatedValue: a[0][0])
	var matrix = [[Double]](count: a.count, repeatedValue: row)
	for i in 0..<a.count {
		if a[i].count != b[i].count {
			return nil
		}
		for j in 0..<matrix[i].count {
			matrix[i][j] = a[i][j] - b[i][j]
		}
	}
	return matrix
}


func transpose<T>(matrix: [[T]]) -> [[T]] {
	guard !matrix.isEmpty else { return matrix }
	let row_count = matrix.count
	let col_count = matrix[0].count
	for column in matrix {
		if column.count != col_count { return matrix }
	}
	let row = [T](count: row_count, repeatedValue: matrix[0][0])
	var transpose_matrix = [[T]](count: col_count, repeatedValue: row)
	for i in 0..<row_count {
		for j in 0..<col_count {
			transpose_matrix[j][i] = matrix[i][j]
		}
	}
	return transpose_matrix
}

/*

m.dotVec = function (vec1, vec2) {
	if (vec1.length === vec2.length) {
		var result = 0;
		for (var i = 0; i < vec1.length; i++) {
			result += vec1[i] * vec2[i];
		}
		return result;
	} else {
		throw new Error("Vector mismatch");
	}
};

m.outerVec = function (vec1,vec2) {
	var mat1 = m.transpose([vec1]);
	var mat2 = [vec2];
	return m.mulMat(mat1,mat2);
};

m.mulVecScalar = function(vec,scalar) {
	var i, result = [];
	for(i=0;i<vec.length;i++)
	result.push(vec[i]*scalar);
	return result;
};

m.mulMatScalar = function(mat,scalar) {
	var row = m.shape(mat)[0];
	var col = m.shape(mat)[1];
	var i , j,result = [];
	for(i=0 ; i<row ; i++) {
		var rowVec = [];
		for(j=0 ; j<col ; j++) {
			rowVec.push(mat[i][j] * scalar);
		}
		result.push(rowVec);
	}
	return result;
};

m.mulMatElementWise = function(mat1, mat2) {
	if (mat1.length === mat2.length && mat1[0].length === mat2[0].length) {
		var result = new Array(mat1.length);
		
		for (var x = 0; x < mat1.length; x++) {
			result[x] = new Array(mat1[0].length);
		}
		
		for (var i = 0; i < result.length; i++) {
			for (var j = 0; j < result[i].length; j++) {
				result[i][j] = mat1[i][j] * mat2[i][j]
			}
		}
		return result;
	} else {
		throw new Error("Matrix shape error : not same");
	}
};

m.mulMat = function (mat1, mat2) {
	if (mat1[0].length === mat2.length) {
		var result = new Array(mat1.length);
		
		for (var x = 0; x < mat1.length; x++) {
			result[x] = new Array(mat2[0].length);
		}
		
		
		var mat2_T = m.transpose(mat2);
		for (var i = 0; i < result.length; i++) {
			for (var j = 0; j < result[i].length; j++) {
				result[i][j] = m.dotVec(mat1[i],mat2_T[j]);
			}
		}
		return result;
	} else {
		throw new Error("Array mismatch");
	}
};

m.sumVec = function(vec) {
	var sum = 0;
	var i = vec.length;
	while (i--) {
		sum += vec[i];
	}
	return sum;
};

m.sumMat = function(mat) {
	var sum = 0;
	var i = mat.length;
	while (i--) {
		for(var j=0;j<mat[0].length;j++)
		sum += mat[i][j];
	}
	return sum;
};

m.sumMatAxis = function(mat,axis) {
	// default axis 0;
	// axis 0 : mean of col vector . axis 1 : mean of row vector
	if(axis === 1) {
		var row = m.shape(mat)[0];
		var i ;
		var result = [];
		for(i=0 ; i<row; i++)
		result.push(m.sumVec(mat[i]));
		return result;
	} else {
		mat_T = m.transpose(mat);
		return m.sumMatAxis(mat_T,1);
	}
};

m.meanVec = function(vec) {
	return 1. * m.sumVec(vec) / vec.length;
};

m.meanMat = function(mat) {
	var row = mat.length;
	var col = mat[0].length;
	return 1. * m.sumMat(mat) / (row * col);
};

m.meanMatAxis = function(mat,axis) {
	// default axis 0;
	// axis 0 : mean of col vector . axis 1 : mean of row vector
	if(axis === 1) {
		var row = m.shape(mat)[0];
		var i ;
		var result = [];
		for(i=0 ; i<row; i++)
		result.push(m.meanVec(mat[i]));
		return result;
	} else {
		mat_T = m.transpose(mat);
		return m.meanMatAxis(mat_T,1);
	}
};

m.squareVec = function(vec) {
	var squareVec = [];
	var i;
	for(i=0;i<vec.length;i++) {
		squareVec.push(vec[i]*vec[i]);
	}
	return squareVec;
};

m.squareMat = function(mat) {
	var squareMat = [];
	var i;
	for(i=0;i<mat.length;i++) {
		squareMat.push(m.squareVec(mat[i]));
	}
	return squareMat;
};

m.minVec = function(vec) {
	var min = vec[0];
	var i = vec.length;
	while (i--) {
		if (vec[i] < min)
		min = vec[i];
	}
	return min;
};

m.maxVec = function(vec) {
	var max = vec[0];
	var i = vec.length;
	while (i--) {
		if (vec[i] > max)
		max = vec[i];
	}
	return max;
}

m.minMat = function(mat) {
	var min = mat[0][0];
	var i = mat.length;
	while (i--) {
		for(var j=0;j<mat[0].length;j++) {
			if(mat[i][j] < min)
			min = mat[i][j];
		}
	}
	return min;
};

m.maxMat = function(mat) {
	var max = mat[0][0];
	var i = mat.length;
	while (i--) {
		for(var j=0;j<mat[0].length;j++) {
			if(mat[i][j] < max)
			max = mat[i][j];
		}
	}
	return max;
};

m.zeroVec = function(n) {
	var vec = [];
	while(vec.length < n)
	vec.push(0);
	return vec;
};

m.zeroMat = function(row,col) {
	var mat = [];
	while(mat.length < row)
	mat.push(m.zeroVec(col));
	return mat;
};

m.oneVec = function(n) {
	var vec = [];
	while(vec.length < n)
	vec.push(1);
	return vec;
};

m.oneMat = function(row,col) {
	var mat = [];
	while(mat.length < row)
	mat.push(m.oneVec(col));
	return mat;
};

m.randVec = function(n,lower,upper) {
	lower = (typeof lower !== 'undefined') ? lower : 0;
	upper = (typeof upper !== 'undefined') ? upper : 1;
	var vec = [];
	while(vec.length < n)
	vec.push(lower + (upper-lower) * Math.random());
	return vec;
};

m.randMat = function(row,col,lower,upper) {
	lower = (typeof lower !== 'undefined') ? lower : 0;
	upper = (typeof upper !== 'undefined') ? upper : 1;
	var mat = [];
	while(mat.length < row)
	mat.push(m.randVec(col,lower,upper));
	return mat;
};

m.randnVec = function(n,mean,sigma) {
	var vec = [];
	while(vec.length < n)
	vec.push(mean+sigma* m.randn());
	return vec;
};

m.randnMat = function(row,col,mean,sigma) {
	var mat = [];
	while(mat.length < row)
	mat.push(m.randnVec(col,mean,sigma));
	return mat;
};

m.identity = function (n) {
	var result = new Array(n);
	
	for (var i = 0; i < n ; i++) {
		result[i] = new Array(n);
		for (var j = 0; j < n; j++) {
			result[i][j] = (i === j) ? 1 : 0;
		}
	}
	
	return result;
};

m.sigmoid = function(x) {
	var sigmoid = (1. / (1 + Math.exp(-x)))
	if(sigmoid ==1) {
		//   console.warn("Something Wrong!! Sigmoid Function returns 1. Probably javascript float precision problem?\nSlightly Controlled value to 1 - 1e-14")
		sigmoid = 0.99999999999999; // Javascript Float Precision Problem.. This is a limit of javascript.
	} else if(sigmoid ==0) {
		//  console.warn("Something Wrong!! Sigmoid Function returns 0. Probably javascript float precision problem?\nSlightly Controlled value to 1e-14")
		sigmoid = 1e-14;
	}
	return sigmoid; // sigmoid cannot be 0 or 1;;
};

m.dSigmoid = function(x){
	a = m.sigmoid(x);
	return a * (1. - a);
};

m.probToBinaryMat = function(mat) {
	var row = m.shape(mat)[0];
	var col = m.shape(mat)[1];
	var i,j;
	var result = [];
	
	for(i=0;i<row;i++) {
		var rowVec = [];
		for(j=0;j<col;j++) {
			if(Math.random() < mat[i][j])
			rowVec.push(1);
			else
			rowVec.push(0);
		}
		result.push(rowVec);
	}
	return result;
};

m.activateVec = function(vec,activation) {
	var i, result = [];
	for(i=0;i<vec.length;i++)
	result.push(activation(vec[i]));
	return result;
};

m.activateMat = function(mat,activation) {
	var row = m.shape(mat)[0];
	var col = m.shape(mat)[1];
	var i, j,result = [];
	for(i=0;i<row;i++) {
		var rowVec = [];
		for(j=0;j<col;j++)
		rowVec.push(activation(mat[i][j]));
		result.push(rowVec);
	}
	return result;
};

m.activateTwoVec = function(vec1, vec2,activation) {
	if (vec1.length === vec2.length) {
		var result = new Array(vec1.length);
		for (var i = 0; i < result.length; i++) {
			result[i] = activation(vec1[i],vec2[i]);
		}
		return result;
	} else {
		throw new Error("Matrix shape error : not same");
	}
};

m.activateTwoMat = function(mat1, mat2,activation) {
	if (mat1.length === mat2.length && mat1[0].length === mat2[0].length) {
		var result = new Array(mat1.length);
		
		for (var x = 0; x < mat1.length; x++) {
			result[x] = new Array(mat1[0].length);
		}
		
		for (var i = 0; i < result.length; i++) {
			for (var j = 0; j < result[i].length; j++) {
				result[i][j] = activation(mat1[i][j],mat2[i][j]);
			}
		}
		return result;
	} else {
		throw new Error("Matrix shape error : not same");
	}
};

m.fillVec = function(n,value) {
	var vec = [];
	while(vec.length < n)
	vec.push(value);
	return vec;
};

m.fillMat = function(row,col,value) {
	var mat = [];
	while(mat.length < row) {
		var rowVec = [];
		while(rowVec.length < col)
		rowVec.push(value);
		mat.push(rowVec);
	}
	return mat;
};

m.softmaxVec = function(vec) {
	var max = m.maxVec(vec);
	var preSoftmaxVec = m.activateVec(vec,function(x) {return Math.exp(x - max);})
	return m.activateVec(preSoftmaxVec,function(x) {return x/ m.sumVec(preSoftmaxVec)})
};

m.softmaxMat = function(mat) {
	var result=[], i;
	for(i=0 ; i<mat.length ; i++)
	result.push(m.softmaxVec(mat[i]));
	return result;
};
*/


// For CRBM
/*
m.phi = function(mat,vec,low,high) {
var i;
var result = [];
for(i=0;i<mat.length;i++) {
result.push(m.activateTwoVec(mat[i],vec,function(x,y){return low+(high-low)* m.sigmoid(x*y);}))
}
return result;
}
*/




















/// 多層感知層之神經網路測試
/*
var pat: [[[Double]]] = [
	// A B C D E F G
	[[1,1,1,1,1,1,0], [0,0,0,0]], // 0
	[[0,1,1,0,0,0,0], [0,0,0,1]], // 1
	[[1,1,0,1,1,0,1], [0,0,1,0]], // 2
	[[1,1,1,1,0,0,1], [0,0,1,1]], // 3
	[[0,1,1,0,0,1,1], [0,1,0,0]], // 4
	[[1,0,1,1,0,1,1], [0,1,0,1]], // 5
	[[1,0,1,1,1,1,1], [0,1,1,0]], // 6
	[[1,1,1,0,0,0,0], [0,1,1,1]], // 7
	[[1,1,1,1,1,1,1], [1,0,0,0]], // 8
	[[1,1,1,1,0,1,1], [1,0,0,1]], // 9
]

// create a network with 7 input, 5 hidden, and 4 output nodes
var nn = NeuralNet(ni: 7, nh: 5, no: 4);
// train it with some patterns
nn.train(pat, iterations: 10000, rate: 0.2, moment: 0.01)
// test it
nn.test(pat)

nn.update([1,0,1,1,0,1,1])
nn.update([1,0,0,1,1,1,0])   //input 圖形C
nn.outputCharacter([1,0,1,1,0,1,1])		//會
nn.outputCharacter([1,0,0,1,1,1,0])		//不會
nn.outputCharacter([1,0,0,0,1,1,1])		//不會

pat = [
	//A B C D E F G
	[[1,1,1,1,1,1,0], [0,0,0,0]], // 0
	[[0,1,1,0,0,0,0], [0,0,0,1]], // 1
	[[1,1,0,1,1,0,1], [0,0,1,0]], // 2
	[[1,1,1,1,0,0,1], [0,0,1,1]], // 3
	[[0,1,1,0,0,1,1], [0,1,0,0]], // 4
	[[1,0,1,1,0,1,1], [0,1,0,1]], // 5
	[[1,0,1,1,1,1,1], [0,1,1,0]], // 6
	[[1,1,1,0,0,0,0], [0,1,1,1]], // 7
	[[1,1,1,1,1,1,1], [1,0,0,0]], // 8
	[[1,1,1,1,0,1,1], [1,0,0,1]], // 9
	[[1,1,1,0,1,1,1], [1,0,1,0]], // A
	[[0,0,1,1,1,1,1], [1,0,1,1]], // B
	[[1,0,0,1,1,1,0], [1,1,0,0]], // C
	[[0,1,1,1,1,0,1], [1,1,0,1]], // D
	[[1,0,0,1,1,1,1], [1,1,1,0]], // E
	[[1,0,0,0,1,1,1], [1,1,1,1]], // F
]

nn = NeuralNet(ni: 7, nh: 5, no: 4);
nn.train(pat, iterations: 10000, rate: 0.2, moment: 0.01)
nn.test(pat)
nn.update([1,0,1,1,0,1,1])
nn.update([1,0,0,1,1,1,0])
nn.outputCharacter([1,0,1,1,0,1,1])		//會			5
nn.outputCharacter([1,0,0,1,1,1,0])		//學會了     C
nn.outputCharacter([1,0,0,0,1,1,1])		//學會了     F

*/
/*:
****
[Next](@next)
*/
