package main

import r "vendor:raylib"

CARD_WIDTH :: 60
CARD_HEIGHT :: 80
CARD_BORDER_WIDTH :: 4
OUTLINE_OFFSET :: 3
CARD_OUTLINE_COLOUR :: r.GREEN
SELECTED_VERTICAL_OFFSET :: 10
HORIZONTAL_SPACING :: CARD_WIDTH / 2

draw_player_hand :: proc() {
	for i in 0 ..< HAND_SIZE {
		if i != selected {
			x := PADDING + i32((HORIZONTAL_SPACING + PADDING) * i)
			y := i32(SCREEN_HEIGHT - PADDING - CARD_HEIGHT)
			draw_card(x, y)
		}
	}

	// always draw selected card on top
	x := PADDING + i32((HORIZONTAL_SPACING + PADDING) * selected)
	y := i32(SCREEN_HEIGHT - PADDING - CARD_HEIGHT - SELECTED_VERTICAL_OFFSET)
	draw_card(x, y)
	draw_card_outline(x, y)
}

draw_opponent_hand :: proc() {
	for i in 0 ..< HAND_SIZE {
		x := PADDING + i32((HORIZONTAL_SPACING + PADDING) * i)
		r.DrawRectangle(x, PADDING, CARD_WIDTH, CARD_HEIGHT, r.BLACK)
	}
}

draw_card :: proc(x, y: i32) {
	r.DrawRectangle(x, y, CARD_WIDTH, CARD_HEIGHT, r.BLACK)
	r.DrawRectangle(
		x + CARD_BORDER_WIDTH,
		y + CARD_BORDER_WIDTH,
		CARD_WIDTH - CARD_BORDER_WIDTH * 2,
		CARD_HEIGHT - CARD_BORDER_WIDTH * 2,
		r.WHITE,
	)
}

draw_card_outline :: proc(x, y: i32) {
	r.DrawRectangleLines(
		x - OUTLINE_OFFSET,
		y - OUTLINE_OFFSET,
		CARD_WIDTH + OUTLINE_OFFSET * 2,
		CARD_HEIGHT + OUTLINE_OFFSET * 2,
		CARD_OUTLINE_COLOUR,
	)
}
