package main

import "core:fmt"
import "core:time"
import r "vendor:raylib"

// keymaps
UP :: r.KeyboardKey.K
DOWN :: r.KeyboardKey.J
LEFT :: r.KeyboardKey.H
RIGHT :: r.KeyboardKey.L

// card counts
INITIAL_HAND :: 8
MONTH_SIZE :: 4
MONTH_COUNT :: 12
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

// state
selection := 0
is_dragging := false

// collections
hand := [dynamic]Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}
table := [dynamic]Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}
opponent := [dynamic]Color{r.BLUE, r.GREEN, r.GREEN, r.RED, r.YELLOW, r.YELLOW, r.BLUE, r.RED}

update :: proc() {
	switch state {
	case .Pause:
		if r.IsKeyPressed(.P) {state = .Play}

	case .Play:
		if r.IsKeyPressed(.P) {state = .Pause}
		if r.IsKeyPressed(LEFT) {selection = max(selection - 1, 0)}
		if r.IsKeyPressed(RIGHT) {selection = min(selection + 1, len(hand) - 1)}

		if r.IsKeyPressed(.ENTER) {
			for card, i in table {
				current := hand[selection]
				if card == current {
					defer ordered_remove(&table, i)
					defer unordered_remove(&hand, selection)
					if selection == len(hand) - 1 {
						selection -= 1
					}
				}
			}
		}

		if r.IsMouseButtonPressed(.LEFT) {is_dragging = true}
		if r.IsMouseButtonReleased(.LEFT) {is_dragging = false}

	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}
