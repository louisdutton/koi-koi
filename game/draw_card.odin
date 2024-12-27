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

draw_visible_hand :: proc(hand: [dynamic]Card) {
	for card, i in hand {
		pos := Vec2{f32(PADDING + (TABLE_SPACING * i)), SCREEN_HEIGHT - PADDING - CARD_SIZE.y}
		draw_card(pos, card)
		if i == state.hand_index {
			draw_card_outline(pos)
		}
	}
}

draw_hidden_hand :: proc(hand: [dynamic]Card) {
	for card, i in hand {
		r.DrawRectangleV(Vec2{f32(PADDING + (TABLE_SPACING) * i), PADDING}, CARD_SIZE, r.BLACK)
	}
}

draw_table :: proc() {
	for card, i in state.table {
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
			Vec2{f32(PADDING + (TABLE_SPACING) * i), SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
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

draw_card :: proc(pos: Vec2, card: Card, border := r.BLACK, alpha: f32 = 1.0) {
	r.DrawRectangleV(pos, CARD_SIZE, r.Fade(border, alpha))
	r.DrawRectangleV(
		pos + CARD_BORDER_WIDTH,
		CARD_SIZE - CARD_BORDER_WIDTH * 2,
		r.Fade(r.WHITE, alpha),
	)
	tex := get_card_texture(card)
	r.DrawTextureEx(tex, pos + CARD_BORDER_WIDTH, 0, 0.102, r.Fade(r.WHITE, alpha))

	when ODIN_DEBUG {
		// card number
		text := strings.clone_to_cstring(fmt.tprintf("%v", u8(card) / MONTH_SIZE + 1))
		defer delete(text)
		font_size: i32 = 20
		text_width: i32 = r.MeasureText(text, font_size)

		r.DrawText(
			text,
			i32(pos.x + CARD_SIZE.x / 2) - text_width / 2,
			i32(pos.y + CARD_SIZE.y / 2) - font_size / 2,
			font_size,
			r.Fade(r.BLACK, alpha),
		)
	}
}

draw_card_outline :: proc(pos: Vec2) {
	rect := Rect {
		pos.x - OUTLINE_OFFSET / 2,
		pos.y - OUTLINE_OFFSET / 2,
		CARD_SIZE.x + OUTLINE_OFFSET,
		CARD_SIZE.y + OUTLINE_OFFSET,
	}
	r.DrawRectangleLinesEx(rect, OUTLINE_THICKNESS, OUTLINE_COLOUR)
}
