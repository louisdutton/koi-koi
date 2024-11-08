package main

import "core:fmt"
import "core:time"
import r "vendor:raylib"

HAND_SIZE :: 8
MONTH_SIZE :: 4
MONTH_COUNT :: 12
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

// ui state
selected_card := 0

// drag and drop
is_dragging := false

// collections
hand := []Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}
table := []Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}
opponent := []Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}

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
