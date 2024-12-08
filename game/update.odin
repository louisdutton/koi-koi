package main

import "core:fmt"
import "core:math"
import "input"

update :: proc() {
	pressed := input.get_pressed()

	switch state.scene {
	case .Pause:
		#partial switch pressed {
		case .PAUSE:
			state.scene = .Play
		}

	case .Play:
		if pressed == .PAUSE {state.scene = .Pause}

		switch state.phase {
		case .PlayerHand:
			#partial switch pressed {
			case .LEFT:
				state.hand_index = max(state.hand_index - 1, 0)
			case .RIGHT:
				state.hand_index = min(state.hand_index + 1, len(state.player.hand) - 1)
			case .SELECT:
				get_matches(state.player.hand[state.hand_index])
				count := len(state.matches)
				switch {
				case count == 1:
					hand_play(&state.player, state.hand_index, state.matches[0])
					start_flip()
				case count >= 2:
					state.phase = .PlayerTable
				case:
					// add card from hand to table
					hand_play(&state.player, state.hand_index)
					start_flip()
				}
			}

		case .PlayerTable:
			#partial switch pressed {
			case .LEFT:
				state.table_index = max(state.table_index - 1, 0)
			case .RIGHT:
				state.table_index = min(state.table_index + 1, len(state.matches) - 1)
			case .SELECT:
				hand_play(&state.player, state.hand_index, state.matches[state.table_index])
				start_flip()
			}

		case .Flip:
			#partial switch pressed {
			case .LEFT:
				state.table_index = max(state.table_index - 1, 0)
			case .RIGHT:
				state.table_index = min(state.table_index + 1, len(state.matches) - 1)
			case .SELECT:
				flip_match(&state.player, state.flip_card, state.table_index)
				state.phase = .OpponentHand
			}

		case .OpponentHand:
			hand_index, table_index := ai_play(state.opponent.hand)
			hand_play(&state.opponent, hand_index, table_index)
			state.phase = .PlayerHand
		}

	case .GameOver:
		#partial switch pressed {
		case .SELECT:
			state.scene = .Play
		}
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
		flip_match(&state.player, state.flip_card, state.matches[0])
		state.phase = .OpponentHand
	case:
		// choose from multiple potential matches
		state.phase = .Flip
	}
}

flip_match :: proc(player: ^Player, card: Card, target_index: int) {
	// add to collection (twice)
	append(&player.collection, card, card)
	ordered_remove(&state.table, target_index)
}

get_matches :: proc(target: Card) {
	clear(&state.matches)
	for card, i in state.table {
		if card_is_same_month(card, target) {
			append(&state.matches, i)
		}
	}
}
