package main

// shifts an index negatively to the left, ensuring it does not go below zero
shift_left :: proc(index: ^int) {
	index^ = max(index^ - 1, 0)
}

// shifts an index positively to the right, ensuring it does not go beyond the last element
shift_right :: proc(index: ^int, count: int) {
	index^ = min(index^ + 1, count - 1)
}
