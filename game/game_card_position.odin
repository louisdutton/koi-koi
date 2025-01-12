package main

import "core:math"
import "core:slice"

prepare_entities :: proc() {
	// player
	player_center := get_center(len(state.player.hand))
	player_y := SCREEN_HEIGHT - PADDING - CARD_SIZE.y
	for &card, i in state.player.hand {
		if anim, anim_index, ok := get_animation(card.card); ok {
			interpolant := f32((state.elapsed - anim.start) / (anim.end - anim.start))
			card.position = lerp_vec2(anim.from, anim.to, ease_out_expo(interpolant))
			if interpolant >= 1 {
				ordered_remove(&animations, anim_index)
			}
		} else {
			card.position = Vec2{player_center + get_x_offset(i), player_y}
		}
		card.flags = {}
		if i == state.hand_index {
			card.flags = {.Outline}
		}
	}

	// opponent
	opponent_center := get_center(len(state.opponent.hand))
	opponent_y: f32 = PADDING
	for &card, i in state.opponent.hand {
		if anim, anim_index, ok := get_animation(card.card); ok {
			interpolant := f32((state.elapsed - anim.start) / (anim.end - anim.start))
			card.position = lerp_vec2(anim.from, anim.to, ease_out_expo(interpolant))
			if interpolant >= 1 {
				ordered_remove(&animations, anim_index)
			}
		} else {
			card.position = Vec2{opponent_center + get_x_offset(i), PADDING}
		}
		card.flags = {.Hidden}
	}

	// table
	table_center := get_center(len(state.table))
	table_y := SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2
	for &card, i in state.table {
		if anim, anim_index, ok := get_animation(card.card); ok {
			interpolant := f32((state.elapsed - anim.start) / (anim.end - anim.start))
			card.position = lerp_vec2(anim.from, anim.to, ease_out_expo(interpolant))
			if interpolant >= 1 {
				ordered_remove(&animations, anim_index)
			}
		} else {
			card.position = Vec2{table_center + get_x_offset(i), table_y}
		}
		card.flags = {}
		#partial switch state.phase {
		case .PlayerTable, .Flip:
			if !slice.contains(state.matches[:], i) {
				card.flags += {.Faded}
			}
			if state.matches[state.table_index] == i {
				card.flags += {.Outline}
			}
		case .PlayerHand:
			if len(state.player.hand) > 0 &&
			   card_is_same_month(card.card, state.player.hand[state.hand_index].card) {
				card.flags += {.Outline}
			}
		}
	}

	// collections

	ROW_MAX :: 5
	X_START :: SCREEN_WIDTH - CARD_SIZE.x - PADDING
	DY := CARD_SIZE.y + PADDING

	// player collection
	for &card, i in state.player.collection {
		card.flags = {}

		if anim, anim_index, ok := get_animation(card.card); ok {
			interpolant := f32((state.elapsed - anim.start) / (anim.end - anim.start))
			card.position = lerp_vec2(anim.from, anim.to, ease_out_expo(interpolant))
			if interpolant >= 1 {
				ordered_remove(&animations, anim_index)
			}
		} else {
			card.position = {
				X_START - f32(TABLE_SPACING * (i % ROW_MAX)),
				player_y + f32(i / ROW_MAX) * -DY,
			}
		}
	}

	// opponent collection
	for &card, i in state.opponent.collection {
		card.flags = {}

		if anim, anim_index, ok := get_animation(card.card); ok {
			interpolant := f32((state.elapsed - anim.start) / (anim.end - anim.start))
			card.position = lerp_vec2(anim.from, anim.to, ease_out_expo(interpolant))
			if interpolant >= 1 {
				ordered_remove(&animations, anim_index)
			}
		} else {
			card.position = {
				X_START - f32(TABLE_SPACING * (i % ROW_MAX)),
				opponent_y + f32(i / ROW_MAX) * DY,
			}
		}
	}
}

@(private = "file")
get_x_offset :: proc(index: int) -> f32 {
	return f32(PADDING + (TABLE_SPACING * index))
}

@(private = "file")
get_center :: proc(count: int) -> f32 {
	return SCREEN_WIDTH / 2 - ((CARD_SIZE.x + PADDING) * f32(count) / 2)
}
