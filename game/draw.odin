package main

import r "vendor:raylib"

PADDING :: 10
FONT_SIZE :: 40
TEXT_COLOUR :: r.WHITE

draw :: proc() {
	r.BeginDrawing()
	defer r.EndDrawing()

	r.ClearBackground(r.GRAY)

	switch state {
	case .Play:
		draw_play()
	case .Pause:
		draw_pause()
	case .GameOver:
		draw_pause()
	}
}

draw_play :: proc() {
	draw_player_hand()
	draw_table()
	draw_opponent_hand()
	draw_deck()
	draw_selected_card() // ontop of everyting else
}

draw_pause :: proc() {
	draw_play()
	fill_screen(r.Fade(r.BLACK, 0.75))
	draw_centered_text("Paused")
}

fill_screen :: proc(color: r.Color) {
	r.DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, color)
}

draw_centered_text :: proc(text: cstring) {
	w := r.MeasureText(text, FONT_SIZE)
	r.DrawText(
		text,
		SCREEN_WIDTH / 2 - w / 2,
		SCREEN_HEIGHT / 2 - FONT_SIZE / 2,
		FONT_SIZE,
		TEXT_COLOUR,
	)
}
