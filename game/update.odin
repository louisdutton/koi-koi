package main

import "core:fmt"
import "core:math"
import r "vendor:raylib"

update :: proc() {
	switch state.scene {
	case .Pause:
		if r.IsKeyPressed(.P) {state.scene = .Play}

	case .Play:
		if r.IsKeyPressed(.P) {state.scene = .Pause}

		switch state.phase {
		case .PlayerHand:
			switch {
			case r.IsKeyPressed(LEFT):
				state.hand_index = max(state.hand_index - 1, 0)
			case r.IsKeyPressed(RIGHT):
				state.hand_index = min(state.hand_index + 1, len(state.player.hand) - 1)
			case r.IsKeyPressed(.ENTER):
				get_matches(state.player.hand[state.hand_index])
				count := len(state.matches)
				switch {
				case count == 1:
					match(state.player.hand[state.hand_index], state.matches[0])
					start_flip()
				case count >= 2:
					state.phase = .PlayerTable
				case:
					// add card from hand to table
					play()
					start_flip()
				}
			}

		case .PlayerTable:
			switch {
			case r.IsKeyPressed(LEFT):
				state.table_index = max(state.table_index - 1, 0)
			case r.IsKeyPressed(RIGHT):
				state.table_index = min(state.table_index + 1, len(state.matches) - 1)
			case r.IsKeyPressed(.ENTER):
				match(state.player.hand[state.hand_index], state.matches[state.table_index])
				start_flip()
			}

		case .Flip:
			switch {
			case r.IsKeyPressed(LEFT):
				state.table_index = max(state.table_index - 1, 0)
			case r.IsKeyPressed(RIGHT):
				state.table_index = min(state.table_index + 1, len(state.matches) - 1)
			case r.IsKeyPressed(.ENTER):
				flip_match(state.flip_card, state.table_index)
				state.phase = .OpponentHand
			}
		case .OpponentHand:
			ai_play()
		case .OpponentTable:
		}

	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state.scene = .Play}
	}
}

start_flip :: proc() {
	state.flip_card = pop(&state.deck)
	get_matches(state.flip_card)
	switch len(state.matches) {
	case 0:
		// can't match so add it to the table and end turn
		append(&state.table, state.flip_card)
		state.phase = .OpponentHand
	case 1:
		// only one match so immediately apply match 
		flip_match(state.flip_card, state.matches[0])
		state.phase = .OpponentHand
	case:
		// choose from multiple potential matches
		state.phase = .Flip
	}
}

// play a card from your hand to the table
play :: proc() {
	append(&state.table, state.player.hand[state.hand_index])
	ordered_remove(&state.player.hand, state.hand_index)
	clamp_selection_index()
}

flip_match :: proc(card: Card, target_index: int) {
	// add to collection (twice)
	append(&state.player.collection, card, card)
	ordered_remove(&state.table, target_index)
}

// play a card in your hand with a card on the table,
// adding both of them to your collection
match :: proc(card: Card, target_index: int) {
	// add to collection (twice)
	append(&state.player.collection, card, card)

	// remove from source
	ordered_remove(&state.table, target_index)
	ordered_remove(&state.player.hand, state.hand_index)

	clamp_selection_index()
}

get_matches :: proc(target: Card) {
	for card, i in state.table {
		if is_match(card, target) {
			append(&state.matches, i)
		}
	}
}

is_match :: proc(a: Card, b: Card) -> bool {
	return a / MONTH_SIZE == b / MONTH_SIZE
}

// prevent out-of-range errors
@(private)
clamp_selection_index :: proc() {
	if state.hand_index == len(state.player.hand) && state.hand_index != 0 {
		state.hand_index -= 1
	}
}
