package main

import "core:log"
import "core:math"
import "core:os"
import "input"

update :: proc(delta: f32, elapsed: f64) {
	handle_input(elapsed)
	prepare_entities(elapsed)
}

handle_input :: proc(elapsed: f64) {
	pressed := input.get_pressed()

	switch state.scene {
	case .Pause:
		#partial switch pressed {
		case .PAUSE: state.scene = .Play
		}

	case .Play:
		if pressed == .PAUSE {state.scene = .Pause}

		switch state.phase {
		case .PlayerHand:
			#partial switch pressed {
			case .LEFT:
				shift_left(&state.hand_index)
			case .RIGHT:
				shift_right(&state.hand_index, len(state.player.hand))
			case .SELECT:
				state.matches = get_matches(
					state.player.hand[state.hand_index].card,
					state.table[:],
				)

				card := state.player.hand[state.hand_index]
				switch len(state.matches) {
				case 0:
					animate_card(card, {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}, elapsed)
					hand_play(&state.player, state.hand_index)
				case 1:
					animate_card(card, {SCREEN_WIDTH, SCREEN_HEIGHT - CARD_SIZE.y}, elapsed)
					hand_play(&state.player, state.hand_index, state.matches[0])
				case:
					set_phase(.PlayerTable) // select from a list
				}
			}

		case .PlayerTable:
			#partial switch pressed {
			case .LEFT:
				shift_left(&state.table_index)
			case .RIGHT:
				shift_right(&state.table_index, len(state.matches))
			case .SELECT:
				card := state.player.hand[state.hand_index]
				animate_card(card, {SCREEN_WIDTH, SCREEN_HEIGHT - CARD_SIZE.y}, elapsed)
				hand_play(&state.player, state.hand_index, state.matches[state.table_index])
			}

		case .Flip:
			#partial switch pressed {
			case .LEFT:
				shift_left(&state.table_index)
			case .RIGHT:
				shift_right(&state.table_index, len(state.matches))
			case .SELECT:
				flip_match(&state.player, state.table_index)
			}

		case .OpponentHand:
			hand_index, table_index := ai_play(state.opponent.hand[:])
			hand_play(&state.opponent, hand_index, table_index)
		}

	case .GameOver:
		#partial switch pressed {
		case .SELECT: state.scene = .Play
		}
	}
}
