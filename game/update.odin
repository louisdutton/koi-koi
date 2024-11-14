package main

import "core:fmt"
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
flip_card: Card

TableIndex :: int

Play_State :: enum u8 {
	Choose_Hand,
	Choose_Table,
	Flip,
	Opponent_Hand,
	Opponent_Table,
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
				selection_hand = min(selection_hand + 1, len(player.hand) - 1)
			case r.IsKeyPressed(.ENTER):
				matches = get_matches(player.hand[selection_hand])
				count := len(matches)
				switch {
				case count == 1:
					match(matches[0])
					start_flip()
				case count >= 2:
					play_state = .Choose_Table
				case:
					// add card from hand to table
					append(&table, player.hand[selection_hand])
					unordered_remove(&player.hand, selection_hand)
					start_flip()
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
				start_flip()
			}

		case .Flip:
			switch {
			case r.IsKeyPressed(LEFT):
				selection_match = max(selection_match - 1, 0)
			case r.IsKeyPressed(RIGHT):
				selection_match = min(selection_match + 1, len(matches) - 1)
			case r.IsKeyPressed(.ENTER):
				flip_match(selection_match)
				play_state = .Opponent_Hand
			}
		case .Opponent_Hand:
			ai_play()
		case .Opponent_Table:
		}

	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}

start_flip :: proc() {
	flip_card = pop(&deck)
	matches = get_matches(flip_card)
	switch len(matches) {
	case 0:
		// can't match so add it to the table and end turn
		append(&table, flip_card)
		play_state = .Opponent_Hand
	case 1:
		// only one match so immediately apply match 
		flip_match(matches[0])
		play_state = .Opponent_Hand
	case:
		// choose from multiple potential matches
		play_state = .Flip
	}
}

flip_match :: proc(target_index: int) {
	ordered_remove(&table, target_index)
	// TODO add matched card to player collection
}

match :: proc(target_index: int) {
	defer ordered_remove(&table, target_index)
	defer unordered_remove(&player.hand, selection_hand)
	if selection_hand == len(player.hand) - 1 {
		selection_hand -= 1
	}
}

get_matches :: proc(target: Card) -> [dynamic]TableIndex {
	matches := [dynamic]int{}
	for card, i in table {
		if is_match(card, target) {
			append(&matches, i)
		}
	}
	return matches
}

is_match :: proc(a: Card, b: Card) -> bool {
	return a / MONTH_SIZE == b / MONTH_SIZE
}
