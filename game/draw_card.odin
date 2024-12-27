package main

import "core:fmt"
import "core:math/rand"
import "core:slice"
import "core:strings"
import r "vendor:raylib"

CARD_SIZE :: Vec2{60, 100}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: r.PINK
OUTLINE_OFFSET :: 0
OUTLINE_THICKNESS :: 4

// debug flags
SHOW_OPPONENTS_HAND :: false

get_center :: proc(cards: []Card) -> f32 {
	count := len(cards)
	return SCREEN_WIDTH / 2 - ((CARD_SIZE.x + PADDING) * f32(count) / 2)
}

draw_visible_hand :: proc(hand: []Card) {
	center := get_center(hand)
	y := SCREEN_HEIGHT - PADDING - CARD_SIZE.y

	for card, i in hand {
		draw_card(
			Vec2{center + f32(PADDING + (TABLE_SPACING * i)), y},
			card,
			i == state.hand_index ? OUTLINE_COLOUR : r.BLACK,
		)
	}
}

draw_hidden_hand :: proc(hand: []Card) {
	center := get_center(hand)

	for card, i in hand {
		r.DrawRectangleV(Vec2{center + f32((TABLE_SPACING) * i), PADDING}, CARD_SIZE, r.BLACK)
	}
}

draw_table :: proc(cards: []Card) {
	center := get_center(cards)

	for card, i in cards {
		alpha: f32 = 1.0
		is_highlighted := false

		#partial switch state.phase {
		case .PlayerTable, .Flip:
			if !slice.contains(state.matches[:], i) {alpha = 0.5}
			is_highlighted = state.matches[state.table_index] == i
		case .PlayerHand:
			if len(state.player.hand) > 0 {
				is_highlighted = card_is_same_month(card, state.player.hand[state.hand_index])
			}
		}

		draw_card(
			Vec2{center + f32((TABLE_SPACING) * i), SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
			card,
			is_highlighted ? OUTLINE_COLOUR : r.BLACK,
			alpha,
		)
	}
}

draw_deck :: proc() {
	if (len(state.deck) > 0) {
		r.DrawRectangleV(
			Vec2{SCREEN_WIDTH * 0.75, SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
			CARD_SIZE,
			r.BLACK,
		)
	}
}

Anchor :: enum u8 {
	TopRight,
	BottomRight,
}

draw_collection :: proc(collection: ^[dynamic]Card, anchor: Anchor) {
	ROW_MAX :: 5
	x_start :: SCREEN_WIDTH - CARD_SIZE.x - PADDING
	y_start: f32
	dy: f32
	switch anchor {
	case .TopRight:
		y_start = PADDING
		dy = CARD_SIZE.y + PADDING
	case .BottomRight:
		y_start = SCREEN_HEIGHT - PADDING - CARD_SIZE.y
		dy = -(CARD_SIZE.y + PADDING)
	}

	for card, i in collection {
		draw_card(
			Vec2{x_start - f32(TABLE_SPACING * (i % ROW_MAX)), y_start + f32(i / ROW_MAX) * dy},
			card,
		)
	}
}

draw_card :: proc(pos: Vec2, card: Card, border := r.BLACK, alpha: f32 = 1.0) {
	r.DrawRectangleV(pos, CARD_SIZE, r.Fade(border, alpha))
	r.DrawRectangleV(
		pos + CARD_BORDER_WIDTH,
		CARD_SIZE - CARD_BORDER_WIDTH * 2,
		r.Fade(r.WHITE, alpha),
	)
	tex := get_card_texture(card)
	r.DrawTextureEx(tex, pos + CARD_BORDER_WIDTH, 0, 0.102, r.Fade(r.WHITE, alpha))
}
