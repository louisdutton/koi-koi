package main

import "core:fmt"
import "core:time"
import r "vendor:raylib"

// keymaps
UP :: r.KeyboardKey.K
DOWN :: r.KeyboardKey.J
LEFT :: r.KeyboardKey.H
RIGHT :: r.KeyboardKey.L

// state
selection := 0
is_dragging := false

Play_State :: enum u8 {
	Choose,
	Match,
	Flip,
}

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
				if matches_selected(card) {
					defer ordered_remove(&table, i)
					defer unordered_remove(&hand, selection)
					if selection == len(hand) - 1 {
						selection -= 1
					}
					break
				}
			}
		}

		if r.IsMouseButtonPressed(.LEFT) {is_dragging = true}
		if r.IsMouseButtonReleased(.LEFT) {is_dragging = false}

	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}

matches_selected :: proc(card: Card) -> bool {
	return card / 12 == hand[selection] / 12
}
