package main

import "core:fmt"
import "core:strings"
import r "vendor:raylib"

PADDING :: 10
FONT_SIZE :: 40
TEXT_COLOUR :: r.WHITE
FONT_CENTER_VERTICAL :: SCREEN_HEIGHT / 2 - FONT_SIZE / 2

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

	// canvas layer
	draw_ui()
}

draw_ui :: proc() {
	text: cstring
	switch play_state {
	case .Choose_Hand:
		text = "Player Hand"
	case .Choose_Table:
		text = "Player Table"
	case .Flip:
		text = "Flip"
	case .Opponent_Hand:
		text = "Opponent Hand"
	case .Opponent_Table:
		text = "Opponent Table"
	}

	draw_centered_text(text, 40)
}

draw_pause :: proc() {
	draw_play()
	fill_screen(r.Fade(r.BLACK, 0.75))
	draw_centered_text("Paused")
}

fill_screen :: proc(color: r.Color) {
	r.DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, color)
}

draw_centered_text :: proc(text: cstring, y: i32 = FONT_CENTER_VERTICAL) {
	w := r.MeasureText(text, FONT_SIZE)
	r.DrawText(text, SCREEN_WIDTH / 2 - w / 2, y, FONT_SIZE, TEXT_COLOUR)
}
