package main

import "core:slice"

CardFlag :: enum u8 {
	Outline,
	Hidden,
	Faded,
}

CardFlags :: bit_set[CardFlag]

CardEntity :: struct {
	card:     Card,
	position: Vec2,
	flags:    CardFlags,
}

prepare_entities :: proc() -> (entities: [dynamic]CardEntity) {
	// player
	player_hand := state.player.hand[:]
	player_center := get_center(player_hand)
	player_y := SCREEN_HEIGHT - PADDING - CARD_SIZE.y
	for card, c in player_hand {
		entity: CardEntity = {
			card     = card,
			position = Vec2{player_center + get_x_offset(c), player_y},
		}
		if c == state.hand_index {
			entity.flags += {.Outline}
		}
		append(&entities, entity)
	}

	// opponent
	opponent_hand := state.opponent.hand[:]
	opponent_center := get_center(opponent_hand)
	opponent_y: f32 = PADDING
	for card, c in opponent_hand {
		append(
			&entities,
			CardEntity {
				card = card,
				position = Vec2{opponent_center + get_x_offset(c), PADDING},
				flags = {.Hidden},
			},
		)
	}

	// table
	table_cards := state.table[:]
	table_center := get_center(table_cards)
	table_y := SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2
	for card, c in table_cards {
		ntt: CardEntity = {
			card     = card,
			position = Vec2{table_center + get_x_offset(c), table_y},
		}
		#partial switch state.phase {
		case .PlayerTable, .Flip:
			if !slice.contains(state.matches[:], c) {
				ntt.flags += {.Faded}
			}
			if state.matches[state.table_index] == c {
				ntt.flags += {.Outline}
			}
		case .PlayerHand:
			if len(state.player.hand) > 0 &&
			   card_is_same_month(card, state.player.hand[state.hand_index]) {
				ntt.flags += {.Outline}
			}
		}
		append(&entities, ntt)
	}

	// collections

	ROW_MAX :: 5
	x_start :: SCREEN_WIDTH - CARD_SIZE.x - PADDING
	dy := CARD_SIZE.y + PADDING

	// player collection
	for card, c in state.player.collection {
		append(
			&entities,
			CardEntity {
				card = card,
				position = Vec2 {
					x_start - f32(TABLE_SPACING * (c % ROW_MAX)),
					player_y + f32(c / ROW_MAX) * -dy,
				},
			},
		)
	}

	// opponent collection
	for card, c in state.opponent.collection {
		append(
			&entities,
			CardEntity {
				card = card,
				position = Vec2 {
					x_start - f32(TABLE_SPACING * (c % ROW_MAX)),
					opponent_y + f32(c / ROW_MAX) * dy,
				},
			},
		)
	}

	return entities
}

@(private = "file")
get_x_offset :: proc(index: int) -> f32 {
	return f32(PADDING + (TABLE_SPACING * index))
}

@(private = "file")
get_center :: proc(cards: []Card) -> f32 {
	count := len(cards)
	return SCREEN_WIDTH / 2 - ((CARD_SIZE.x + PADDING) * f32(count) / 2)
}
