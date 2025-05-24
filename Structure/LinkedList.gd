extends Reference

class_name LinkedList

class LinkedListNode:
	var prevous = null
	var next = null
	var data = null
	
	func _init(val):
		data = val

var head: LinkedListNode = null
var tail:LinkedListNode = head
var size = 0

func getSize():
	return size

func addFirst(val):
	print_debug("adding data to front")
	if size == 0:
		head = LinkedListNode.new(val)
		tail = head
		print("data added")
	else:
		var new_head = LinkedListNode.new(val)
		head.prevous = new_head
		new_head.next = head
		tail = head
		head = new_head
		print("data added")
	size += 1

func addLast(val):
	print_debug("adding data to back")
	if size == 0:
		head = LinkedListNode.new(val)
		tail = head
		print("data added")
	else:
		var new_tail = LinkedListNode.new(val)
		tail.next = new_tail
		new_tail.prevous = tail
		head = tail
		tail = new_tail
		print("data added")
	size += 1

func insertBefore(node:LinkedListNode, val):
	print_debug("inserting data")
	var nodeInsert = LinkedListNode.new(val)
	var previous = node.previous
	previous.next = nodeInsert
	nodeInsert.next = node
	node.prevous = nodeInsert
	print("data added")
	size += 1

func converttoArray():
	print_debug("converting data to array format")
	var current = head
	var array:Array = Array()
	while current != null:
		array.append(current.data)
		current = current.next
	print("data converted")
	return array










