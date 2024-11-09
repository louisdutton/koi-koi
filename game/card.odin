package main

import "core:fmt"
import "core:math/rand"
import "core:strings"
import r "vendor:raylib"

CARD_SIZE :: Vec2{60, 90}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
HAND_SPACING :: int(CARD_SIZE.x / 2)
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: r.PINK
OUTLINE_OFFSET :: 0
OUTLINE_THICKNESS :: 4

draw_player_hand :: proc() {
	for card, i in hand {
		if i != selection {
			draw_card(
				Vec2{f32(PADDING + (HAND_SPACING * i)), SCREEN_HEIGHT - PADDING - CARD_SIZE.y},
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
			f32(PADDING + (HAND_SPACING * selection)),
			SCREEN_HEIGHT - PADDING - CARD_SIZE.y - SELECTED_VERTICAL_OFFSET,
		}
	}

	draw_card(pos, hand[selection])
	draw_card_outline(pos)
}

draw_opponent_hand :: proc() {
	for card, i in opponent {
		r.DrawRectangleV(
			Vec2{f32(PADDING + (HAND_SPACING + PADDING) * i), PADDING},
			CARD_SIZE,
			r.BLACK,
		)
	}
}

draw_table :: proc() {
	for card, i in table {
		border_colour := matches_selected(card) ? OUTLINE_COLOUR : r.BLACK
		draw_card(
			Vec2{f32(PADDING + (TABLE_SPACING) * i), SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
			card,
			border_colour,
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

draw_card :: proc(pos: Vec2, card: Card, border := r.BLACK) {
	r.DrawRectangleV(pos, CARD_SIZE, border)
	r.DrawRectangleV(pos + CARD_BORDER_WIDTH, CARD_SIZE - CARD_BORDER_WIDTH * 2, r.WHITE)

	// card number
	text := strings.clone_to_cstring(fmt.tprintf("%v", card / 12))
	font_size: i32 = 20
	text_width: i32 = r.MeasureText(text, font_size)

	r.DrawText(
		text,
		i32(pos.x + CARD_SIZE.x / 2) - text_width / 2,
		i32(pos.y + CARD_SIZE.y / 2) - font_size / 2,
		font_size,
		r.BLACK,
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
