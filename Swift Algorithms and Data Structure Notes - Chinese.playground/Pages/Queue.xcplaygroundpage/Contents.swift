/*:
[Previous](@previous)
_____________________
# 大量 Data 資料結構 :
### Queue / Stack
_____________________
## Queue

![](Data8.png "")

繁中「佇列」，簡中「队列」。像排隊，維持資料前後順序。

![](Data9.png "")

Array 和 List 皆可實作。

插入、刪除需時 O(1) 。搜尋需時 O(N) 。

佇列有暫留的性質。

可以直接使用 STL 的 queue 。

[10935]:http://uva.onlinejudge.org/external/109/10935.html ""
[11995]:http://uva.onlinejudge.org/external/119/11995.html ""
[12100]:http://uva.onlinejudge.org/external/121/12100.html ""
[1598]:http://uva.onlinejudge.org/external/15/1598.html ""


_____________________
UVa [10935], UVa [11995], UVa [12100], UVa [1598]
_____________________
## 特殊的 Queue
_____________________

![](Data10.png "")

記憶體循環使用，稱作 Circular Queue 。

![](Data11.png "")

資料保持排序，可以隨時得到最小（大）值，稱作 Priority Queue 。資料保持排序，可以隨時得到最小值、最大值，稱作 Double Ended Priority Queue 。
_____________________
## Deque （ Double Ended Queue ）
_____________________

![](Data14.png "")

兩頭皆能插入與刪除，稱作 Deque ，同時有著 Stack 和 Queue 的功效。

![](Data15.png "")

Array 和 Doubly Linked List 皆可實作。

可以直接使用 STL 的 deque 。

[12207]:http://uva.onlinejudge.org/external/122/12207.html ""

_____________________
UVa [12207]
_____________________
*/
//: # Queue(佇列)
//: A queue is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!
//:
//: Why would you need this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.
//:
//: A queue gives you a FIFO or first-in, first-out order. The element you inserted first is also the first one to come out again. It's only fair! (A very similar data structure, the [stack](../Stack/), is LIFO or last-in first-out.)
//: For example, let's enqueue a number:
//:
//:		queue.enqueue(10)
//:
//: The queue is now `[10]`. Add the next number to the queue:
//: 
//:		queue.enqueue(3)
//:
//: The queue is now `[10, 3]`. Add one more number:
//:
//:		queue.enqueue(57)
//:
//: The queue is now `[10, 3, 57]`. Let's dequeue to pull the first element off the front of the queue:
//:
//:		queue.dequeue()
//:
//: This returns `10` because that was the first number we inserted. The queue is now `[3, 57]`. Everyone moved up by one place.
//: 
//:		queue.dequeue()
//:
//: This returns `3`, the next dequeue returns `57`, and so on. If the queue is empty, dequeuing returns `nil` or in some implementations it gives an error message.
//:
//: > **Note:** A queue is not always the best choice. If the order in which the items are added and removed from the list isn't important, you might as well use a [stack](../Stack/) instead of a queue. Stacks are simpler and faster.
//:
//: Here is a very simplistic implementation of a queue in Swift. It's just a wrapper around an array that lets you enqueue, dequeue, and peek at the front-most item:
/*
 * Queue
 * A queue is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!
 * A queue gives you a FIFO or first-in, first-out order. The element you inserted first is also the first one to come out again. It's only fair!
 * In this implementation, enqueuing is an O(1) operation, dequeuing is O(n).
 */
public struct Queue<T> {
	private var array = [T]()
	
	public var count: Int {
		return array.count
	}
	
	public var isEmpty: Bool {
		return array.isEmpty
	}
	
	public mutating func enqueue(element: T) {
		array.append(element)
	}
	
	public mutating func dequeue() -> T? {
		if count == 0 {
			return nil
		} else {
			return array.removeFirst()
		}
	}
	
	public func peek() -> T? {
		return array.first
	}
}
//: Create a queue and put some elements on it already.
var queueOfNames = Queue(array: ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"])
//: Adds an element to the end of the queue.
queueOfNames.enqueue("Mike")
//: Queue is now ["Carl", "Lisa", "Stephanie", "Jeff", "Wade", "Mike"]
print(queueOfNames.array)
//: Remove and return the first element in the queue. This returns "Carl".
queueOfNames.dequeue()
//: Return the first element in the queue.
//: Returns "Lisa" since "Carl" was dequeued on the previous line.
queueOfNames.peek()
//: Check to see if the queue is empty.
//: Returns "false" since the queue still has elements in it.
queueOfNames.isEmpty
//: This queue works just fine but it is not optimal.
//:
//: Enqueuing is an **O(1)** operation because adding to the end of an array always takes the same amount of time, regardless of the size of the array. So that's great.
//:
//: However, to dequeue we remove the element from the beginning of the array. This is an **O(n)** operation because it requires all remaining array elements to be shifted in memory.
//:
//: More efficient implementations would use a linked list, a [circular buffer](../Ring Buffer/), or a [heap](../Heap/). (I might add an example of this later.)
//:
//: Variations on this theme are [deque](../Deque/), a double-ended queue where you can enqueue and dequeue at both ends, and [priority queue](../Priority Queue/), a sorted queue where the "most important" item is always at the front.
//:
//: *Written by Matthijs Hollemans*
//:
//: [Next](@next)
