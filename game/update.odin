package main

import "core:log"
import "core:math"
import "core:os"
import "input"

update :: proc(delta: f32, elapsed: f64) {
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
				switch len(state.matches) {
				case 0:
					hand_play(&state.player, state.hand_index)
				case 1:
					hand_play(&state.player, state.hand_index, state.matches[0])
				case:
					set_phase(.PlayerTable) // select from a list
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
			}

		case .Flip:
			#partial switch pressed {
			case .LEFT:
				state.table_index = max(state.table_index - 1, 0)
			case .RIGHT:
				state.table_index = min(state.table_index + 1, len(state.matches) - 1)
			case .SELECT:
				flip_match(&state.player, state.table_index)
			}

		case .OpponentHand:
			hand_index, table_index := ai_play(state.opponent.hand)
			hand_play(&state.opponent, hand_index, table_index)
		}

	case .GameOver:
		#partial switch pressed {
		case .SELECT:
			state.scene = .Play
		}
	}
}

start_flip :: proc(player: ^Player) {
	state.flip_card = pop(&state.deck)
	get_matches(state.flip_card)
	switch len(state.matches) {
	// can't match so add it to the table and end turn
	case 0:
		flip_play()

	// only one match so immediately apply match 
	case 1:
		flip_match(player, state.matches[0])

	// choose from multiple potential matches
	case:
		if state.phase == .OpponentHand {
			// ai autoselect
			flip_match(player, ai_choose_match(state.matches))
		} else {
			// manual select
			set_phase(.Flip)
		}
	}
}

end_turn :: proc() {
	#partial switch state.phase {
	case .PlayerHand, .PlayerTable, .Flip:
		if collection_has_set(state.player.collection) {
			win()
		}
		set_phase(.OpponentHand)
	case .OpponentHand:
		if collection_has_set(state.opponent.collection) {
			lose()
		}
		set_phase(.PlayerHand)
	case:
		log.panicf("can't end turn from phase %e", state.phase)
	}
}

set_phase :: proc(phase: Phase) {
	state.phase = phase
}

// play the flipped card onto the table without matching
// ends the current turn on completion
flip_play :: proc() {
	log.debug("flip-play", state.phase, state.flip_card)
	append(&state.table, state.flip_card)
	end_turn()
}

// match the flipped card with a card on the table
// ends the current turn on completion
flip_match :: proc(player: ^Player, target_index: int) {
	log.debug("flip-match", state.phase, state.flip_card, state.table[target_index])
	append(&player.collection, state.flip_card, state.table[target_index])
	ordered_remove(&state.table, target_index)
	end_turn()
}

get_matches :: proc(target: Card) {
	clear(&state.matches)
	for card, i in state.table {
		if card_is_same_month(card, target) {
			append(&state.matches, i)
		}
	}
}
