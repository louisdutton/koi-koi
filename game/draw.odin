package main

import r "vendor:raylib"

PADDING :: 10

CARD_WIDTH :: 40
CARD_HEIGHT :: 60
CARD_BORDER_WIDTH :: 3

OUTLINE_OFFSET :: 3

HAND_SIZE :: 8

draw :: proc() {
	if r.IsKeyPressed(LEFT) {selected = max(selected - 1, 0)}
	if r.IsKeyPressed(RIGHT) {selected = min(selected + 1, HAND_SIZE - 1)}

	r.BeginDrawing()
	defer r.EndDrawing()

	r.ClearBackground(r.GRAY)

	#partial switch state {
	case .Play:
		draw_play()
	}
}

selected := 0

draw_play :: proc() {
	// player
	for i in 0 ..< HAND_SIZE {
		x := PADDING + i32((CARD_WIDTH + PADDING) * i)
		y := i32(SCREEN_HEIGHT - PADDING - CARD_HEIGHT)
		r.DrawRectangle(x, y, CARD_WIDTH, CARD_HEIGHT, r.BLACK)
		r.DrawRectangle(
			x + CARD_BORDER_WIDTH,
			y + CARD_BORDER_WIDTH,
			CARD_WIDTH - CARD_BORDER_WIDTH * 2,
			CARD_HEIGHT - CARD_BORDER_WIDTH * 2,
			r.WHITE,
		)

		if selected == i {
			r.DrawRectangleLines(
				x - OUTLINE_OFFSET,
				y - OUTLINE_OFFSET,
				CARD_WIDTH + OUTLINE_OFFSET * 2,
				CARD_HEIGHT + OUTLINE_OFFSET * 2,
				r.BLUE,
			)
		}
	}

	// opponent
	for i in 0 ..< HAND_SIZE {
		x := PADDING + i32((CARD_WIDTH + PADDING) * i)
		r.DrawRectangle(x, PADDING, CARD_WIDTH, CARD_HEIGHT, r.BLACK)
	}
}
