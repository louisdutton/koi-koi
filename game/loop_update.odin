package main

import "core:log"
import "core:math"
import "core:os"
import "input"

PLAYER_COLLECTION_ANCHOR :: Vec2{SCREEN_WIDTH - CARD_SIZE.x, SCREEN_HEIGHT - CARD_SIZE.y}
OPPONENT_COLLECTION_ANCHOR :: Vec2{SCREEN_WIDTH - CARD_SIZE.x, CARD_SIZE.y}
TABLE_ANCHOR :: Vec2{SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}

update :: proc() {
	handle_input()
	prepare_entities()
}

handle_input :: proc() {
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
					hand_play(&state.player, state.hand_index)
				case 1:
					hand_match(&state.player, state.hand_index, state.matches[0])
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
				hand_match(&state.player, state.hand_index, state.matches[state.table_index])
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
			if idx, ok := table_index.?; ok {
				hand_match(&state.opponent, hand_index, idx)
			} else {
				hand_play(&state.opponent, hand_index)
			}
		}

	case .GameOver:
	//#partial switch pressed {
	//case .SELECT: state.scene = .Play
	//}
	}
}
