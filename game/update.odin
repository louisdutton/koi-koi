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
selection_hand := 0
selection_match := 0
is_dragging := false
matches := [dynamic]int{} // array of table indices

Play_State :: enum u8 {
	Choose_Hand,
	Choose_Table,
	Flip,
}

play_state := Play_State.Choose_Hand

update :: proc() {
	switch state {
	case .Pause:
		if r.IsKeyPressed(.P) {state = .Play}

	case .Play:
		if r.IsKeyPressed(.P) {state = .Pause}

		switch play_state {
		case .Choose_Hand:
			switch {
			case r.IsMouseButtonPressed(.LEFT):
				is_dragging = true
			case r.IsMouseButtonReleased(.LEFT):
				is_dragging = false
			case r.IsKeyPressed(LEFT):
				selection_hand = max(selection_hand - 1, 0)
			case r.IsKeyPressed(RIGHT):
				selection_hand = min(selection_hand + 1, len(hand) - 1)
			case r.IsKeyPressed(.ENTER):
				matches = get_matches()
				count := len(matches)
				switch {
				case count == 1:
					match(matches[0])
				case count >= 2:
					play_state = .Choose_Table
				}
			}

		case .Choose_Table:
			switch {
			case r.IsKeyPressed(LEFT):
				selection_match = max(selection_match - 1, 0)
			case r.IsKeyPressed(RIGHT):
				selection_match = min(selection_match + 1, len(matches) - 1)
			case r.IsKeyPressed(.ENTER):
				match(matches[selection_match])
				play_state = .Choose_Hand
			}

		case .Flip:
		}


	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}

match :: proc(target_index: int) {
	defer ordered_remove(&table, target_index)
	defer unordered_remove(&hand, selection_hand)
	if selection_hand == len(hand) - 1 {
		selection_hand -= 1
	}
}

get_matches :: proc() -> [dynamic]int {
	matches := [dynamic]int{}
	for card, i in table {
		if matches_selected(card) {
			append(&matches, i)
		}
	}
	return matches
}

matches_selected :: proc(card: Card) -> bool {
	return card / 12 == hand[selection_hand] / 12
}
