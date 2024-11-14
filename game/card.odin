package main

import "core:fmt"
import "core:math/rand"
import "core:slice"
import "core:strings"
import r "vendor:raylib"

CARD_SIZE :: Vec2{60, 90}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: r.PINK
OUTLINE_OFFSET :: 0
OUTLINE_THICKNESS :: 4

// debug flags
SHOW_OPPONENTS_HAND :: false

draw_player_hand :: proc() {
	for card, i in hand {
		if i != selection_hand {
			draw_card(
				Vec2{f32(PADDING + (TABLE_SPACING * i)), SCREEN_HEIGHT - PADDING - CARD_SIZE.y},
				card,
			)
		}
	}
}

draw_selected_card :: proc() {
	pos: Vec2
	if (is_dragging) {
		pos = r.GetMousePosition() - CARD_SIZE / 2
	} else {
		pos = {
			f32(PADDING + (TABLE_SPACING * selection_hand)),
			SCREEN_HEIGHT - PADDING - CARD_SIZE.y - SELECTED_VERTICAL_OFFSET,
		}
	}

	draw_card(pos, hand[selection_hand])
	draw_card_outline(pos)
}

draw_opponent_hand :: proc() {
	for card, i in opponent {
		when SHOW_OPPONENTS_HAND {
			draw_card(Vec2{f32(PADDING + (TABLE_SPACING) * i), PADDING}, card)
		} else {
			r.DrawRectangleV(Vec2{f32(PADDING + (TABLE_SPACING) * i), PADDING}, CARD_SIZE, r.BLACK)

		}
	}
}

draw_table :: proc() {
	for card, i in table {
		alpha: f32 = 1.0
		if play_state == .Choose_Table && !slice.contains(matches[:], i) {alpha = 0.5}
		is_highlighted :=
			play_state == .Choose_Table ? matches[selection_match] == i : is_match(card, hand[selection_hand])
		draw_card(
			Vec2{f32(PADDING + (TABLE_SPACING) * i), SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
			card,
			is_highlighted ? OUTLINE_COLOUR : r.BLACK,
			alpha,
		)
	}
}

draw_deck :: proc() {
	if (len(deck) > 0) {
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

	// card number
	text := strings.clone_to_cstring(fmt.tprintf("%v", card / MONTH_SIZE + 1))
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

draw_card_outline :: proc(pos: Vec2) {
	rect := Rect {
		pos.x - OUTLINE_OFFSET / 2,
		pos.y - OUTLINE_OFFSET / 2,
		CARD_SIZE.x + OUTLINE_OFFSET,
		CARD_SIZE.y + OUTLINE_OFFSET,
	}
	r.DrawRectangleLinesEx(rect, OUTLINE_THICKNESS, OUTLINE_COLOUR)
}
