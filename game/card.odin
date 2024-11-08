package main

import "core:math/rand"
import r "vendor:raylib"

CARD_SIZE :: r.Vector2{60, 80}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
HAND_SPACING :: int(CARD_SIZE.x / 2)
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: r.WHITE
OUTLINE_OFFSET :: 10
OUTLINE_THICKNESS :: 3

draw_player_hand :: proc() {
	for col, i in hand {
		if i != selected_card {
			draw_card(
				r.Vector2 {
					f32(PADDING + (HAND_SPACING * i)),
					SCREEN_HEIGHT - PADDING - CARD_SIZE.y,
				},
				col,
			)
		}
	}

	pos: r.Vector2
	if (is_dragging) {
		pos = r.GetMousePosition() - CARD_SIZE / 2
	} else {
		pos = r.Vector2 {
			f32(PADDING + (HAND_SPACING * selected_card)),
			SCREEN_HEIGHT - PADDING - CARD_SIZE.y - SELECTED_VERTICAL_OFFSET,
		}
	}

	draw_card(pos, hand[selected_card])
	draw_card_outline(pos)
}

draw_opponent_hand :: proc() {
	for i in 0 ..< HAND_SIZE {
		pos := r.Vector2{f32(PADDING + (HAND_SPACING + PADDING) * i), PADDING}
		r.DrawRectangleV(pos, CARD_SIZE, r.BLACK)
	}
}

draw_table :: proc() {
	for col, i in table {
		draw_card(
			r.Vector2{f32(PADDING + (TABLE_SPACING) * i), SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
			col,
		)
	}
}

draw_card :: proc(pos: r.Vector2, color: r.Color) {
	r.DrawRectangleV(pos, CARD_SIZE, r.BLACK)
	r.DrawRectangleV(pos + CARD_BORDER_WIDTH, CARD_SIZE - CARD_BORDER_WIDTH * 2, color)
}

draw_card_outline :: proc(pos: r.Vector2) {
	rect := r.Rectangle {
		pos.x - OUTLINE_OFFSET / 2,
		pos.y - OUTLINE_OFFSET / 2,
		CARD_SIZE.x + OUTLINE_OFFSET,
		CARD_SIZE.y + OUTLINE_OFFSET,
	}
	r.DrawRectangleLinesEx(rect, OUTLINE_THICKNESS, OUTLINE_COLOUR)
}
