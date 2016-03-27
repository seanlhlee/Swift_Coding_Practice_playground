//: [Previous](@previous)
/*
# Heap

Written for the Swift Algorithm Club by [Kevin Randrup](http://www.github.com/kevinrandrup).

## Intro

A heap is a specialized type of tree with only two operations, `insert()` and `remove()`. Heaps are usually implemented using an array.

In Swift, a Heap protocol would look something like this:

```swift
protocol Heap {
typealias Value
func insert(value: Value)
func remove() -> Value?
}
```

## Heap Property

In any given heap, ether every parent node is greater than its child nodes or every parent is less than its child nodes. This "heap property" is true for every single node in the tree.

An example:

```
(10)
/   \
(7)   (2)
/  \
(5) (1)
```

The heap property for this tree is satisfied because every parent node is greater than its children node. `(10)` is greater than `(7)` and `(3)`. `(7)` is greater than `(3)` and `(1)`.

## So what's the problem with trees?

### The balancing issue

If you randomly add and remove data, trees will have `O(log(n))` performance. Unfortunatly our data ususally isn't perfectly random so tree can become unbalanced and take more than `O(log(n))` time. There are a lot of ways to combat this issue in trees (see Binary Trees, AVL tree, Red-Black Tree) but with heaps we don't actually need the entire tree to be sorted. We just want the heap property to be fullfilled.

### The memory issue

Trees also take up more memory than they data they store. You need to allocate memory for nodes and pointers to the left/right child nodes. Compare this to an [array](../Fixed Size Array).

```
(10)
/   \
(7)   (2)
/  \
(5) (1)
```

Notice that if you go horizontally accross the tree shown above, the values are in no particular order; it does not matter whether `(7)` is greater than or less that `(2)`, as long as they are both less than `(10)`.  The lack of order means we can fill out our tree one row at a time, as long as we maintain the heap property.

## The solution

Adding only to the end of the heap allows us to implement the Heap with an array; this may seem like an odd way to implement a tree-like structure but it is very efficient in both time and space. This is how we're going to store the array shown above:

```
[10|7|2|5|1]
```

We can use simple path to find the parent or child node for a node at a particular index. Let's create a mapping of the array indexes to figure out how they relate:

|Child Node|Parent Node|
|----------|-----------|
|   1,2    |     0     |
|   3,4    |     1     |
|   5,6    |     2     |
|   7,8    |     3     |

Using integer arithmetic and division the solution is a trivial computation:

```swift
childOne = (parent * 2) + 1
childTwo = childOne + 1 = (parent * 2) + 2
parent = (child - 1) / 2
```

These equations let us find the parent or child index for any node in `O(1)` time without using nodes; this means we don't need to use extra memory to allocate nodes that contain data and references to the left and right children. We can also append a node to the end of the array in `O(1)` time.

## Insertion

Lets go through an example insertion. Lets insert `(6)` into this heap:

```
(10)
/   \
(7)   (2)
/  \
(5) (1)
```

Lets add `(6)` to the last available space on the last row.

```
(10)
/    \
(7)    (2)
/  \    /
(5) (1) (6)
```

Unfortunately, the heap property is no longer satisfied because `(2)` is above `(6)` and we want higher numbers above lower numbers. We're just going to swap `(6)` and `(2)` to restore the heap property. We keep swapping our inserted value with its parent until the parent is larger or until we get to the top of the tree. This is called **shift-up** or **sifting** and is done after every insertion. The time required for shifting up is proportional to the height of the tree so it takes `O(log(n))` time.

```
(10)
/    \
(7)    (6)
/  \    /
(5) (1) (2)
```


## Removal

The `remove()` method is implemented similar to `insert()`. Lets remove 10 from the previous tree:

```
(10)
/   \
(7)   (2)
/  \
(5) (1)
```

So what happens to the empty spot at the top?

```
(??)       (10)
/   \
(7)   (2)
/  \
(5) (1)
```

Like `insert()`, we're going to take the last object we have, stick it up on top of the tree, and restore the heap property.

```
(1)       (10)
/   \
(7)   (2)
/
(5)
```

Let's look at how to **shift-down** `(1)`. To maintain the heap property, we want to the highest number of top. We have 2 candidates for swapping places with `(1)`: `(7)` and `(2)`. Choose the highest number between these three nodes to be on top; this is `(7)`, so swapping `(1)` and `(7)` gives us the following tree.

```
(7)       (10)
/   \
(1)   (2)
/
(5)
```

Keep shifting down until the node doesn't have any children or it's largest than both its children. The time required for shifting all the way down is proportional to the height of the tree so it takes `O(log(n))` time. For our heap we only need 1 more swap to restore the heap property.

```
(7)
/   \
(5)   (2)
/
(1)
```

Finally we can return `(10)`.

## See also

[Heap on Wikipedia](https://en.wikipedia.org/wiki/Heap_%28data_structure%29)

*/

//
//  Heap.swift
//  Written for the Swift Algorithm Club by Kevin Randrup
//

/**
* A heap is a type of tree data structure with 2 characteristics:
* 1. Parent nodes are either greater or less than each one of their children (called max heaps and min heaps respectively)
* 2. Only the top item is accessible (greatest or smallest)
*
* This results in a data structure that stores n items in O(n) space. Both insertion and deletion take O(log(n)) time (amortized).
*/
protocol Heap {
	typealias Value
	mutating func insert(value: Value)
	mutating func remove() -> Value?
	var count: Int { get }
	var isEmpty: Bool { get }
}

/**
* A MaxHeap stores the highest items at the top. Calling remove() will return the highest item in the heap.
*/
public struct MaxHeap<T : Comparable> : Heap {
	
	typealias Value = T
	
	/**   10
	*  7    5
	* 1 2  3
	* Will be represented as [10, 7, 5, 1, 2, 3]
	*/
	private var mem: [T]
	
	init() {
		mem = [T]()
	}
	
	init(array: [T]) {
		self.init()
		//This could be optimized into O(n) time using the Floyd algorithm instead of O(nlog(n))
		mem.reserveCapacity(array.count)
		for value in array {
			insert(value)
		}
	}
	
	public var isEmpty: Bool {
		return mem.isEmpty
	}
	
	public var count: Int {
		return mem.count
	}
	
	/**
	* Inserts the value into the Heap in O(log(n)) time
	*/
	public mutating func insert(value: T) {
		mem.append(value)
		shiftUp(index: mem.count - 1)
	}
	
	public mutating func insert<S : SequenceType where S.Generator.Element == T>(sequence: S) {
		for value in sequence {
			insert(value)
		}
	}
	
	/**
	* Removes the max value from the heap in O(logn)
	*/
	public mutating func remove() -> T? {
		//Handle empty/1 element cases.
		if mem.isEmpty {
			return nil
		}
		else if mem.count == 1 {
			return mem.removeLast()
		}
		
		
		// Pull the last element up to replace the first one
		let value = mem[0]
		let last = mem.removeLast()
		mem[0] = last
		
		//Downshift the new top value
		shiftDown()
		
		return value
	}
	
	//MARK: Private implmentation
	
	/**
	* Returns the parent's index given the child's index.
	* 1,2 -> 0
	* 3,4 -> 1
	* 5,6 -> 2
	* 7,8 -> 3
	*/
	private func parentIndex(childIndex childIndex: Int) -> Int {
		return (childIndex - 1) / 2
	}
	
	private func firstChildIndex(index: Int) -> Int {
		return index * 2 + 1
	}
	
	@inline(__always) private func validIndex(index: Int) -> Bool {
		return index < mem.endIndex
	}
	
	/**
	* Restore the heap property above a given index.
	*/
	private mutating func shiftUp(index index: Int) {
		var childIndex = index
		let child = mem[childIndex]
		while childIndex != 0 {
			let parentIdx = parentIndex(childIndex: childIndex)
			let parent = mem[parentIdx]
			//If the child doesn't need to be swapped up, return
			if child <= parent {
				return
			}
			//Otherwise, swap the child up the tree
			mem[parentIdx] = child
			mem[childIndex] = parent
			
			//Update childIdx
			childIndex = parentIdx
		}
	}
	
	/**
	* Maintains the heap property of parent > both children
	*/
	private mutating func shiftDown(index index: Int = 0) {
		var parentIndex = index
		var leftChildIndex = firstChildIndex(parentIndex)
		
		//Loop preconditions: parentIndex and left child index are set
		while (validIndex(leftChildIndex)) {
			let rightChildIndex = leftChildIndex + 1
			let highestIndex: Int
			
			//If we have valid right and left indexes, choose the highest one
			if (validIndex(rightChildIndex)) {
				let left = mem[leftChildIndex]
				let right = mem[rightChildIndex]
				highestIndex = (left > right) ? leftChildIndex : rightChildIndex
			} else {
				highestIndex = leftChildIndex
			}
			
			//If the child > parent, swap them
			let parent = mem[parentIndex]
			let highestChild = mem[highestIndex]
			if highestChild <= parent { return }
			
			mem[parentIndex] = highestChild
			mem[highestIndex] = parent
			
			//Set the loop preconditions
			parentIndex = highestIndex
			leftChildIndex = firstChildIndex(parentIndex)
		}
	}
}
//: [Next](@next)
