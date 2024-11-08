package main

import "core:fmt"
import "core:time"
import r "vendor:raylib"

HAND_SIZE :: 8

selected_card := 0

Vec2 :: distinct [2]int

// drag and drop
is_dragging := false
card_position := Vec2{0, 0}

update :: proc() {

	switch state {
	case .Pause:
		if r.IsKeyPressed(.P) {state = .Play}

	case .Play:
		if r.IsKeyPressed(.P) {state = .Pause}
		if r.IsKeyPressed(LEFT) {selected_card = max(selected_card - 1, 0)}
		if r.IsKeyPressed(RIGHT) {selected_card = min(selected_card + 1, HAND_SIZE - 1)}

		if r.IsMouseButtonPressed(.LEFT) {is_dragging = true}
		if r.IsMouseButtonReleased(.LEFT) {is_dragging = false}

	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}
