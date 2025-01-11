package main

import "color"
import "core:reflect"

PADDING :: 10
FONT_SIZE :: 40
TEXT_COLOUR :: color.WHITE
FONT_CENTER_VERTICAL :: SCREEN_HEIGHT / 2 - FONT_SIZE / 2
bg_overlay := color.fade(color.BLACK, 0.75)

draw :: proc(dt: f32) {
	draw_start()
	defer draw_end()

	clear_screen(color.GRAY)

	switch state.scene {
	case .Play:
		draw_play()
	case .Pause:
		draw_pause()
	case .GameOver:
		draw_game_over()
	}
}

@(private = "file")
draw_play :: proc() {
	// collection
	draw_deck()

	// individual cards
	entities := prepare_entities()
	defer delete(entities)
	for card, i in entities[:] {
		draw_card(card)
	}

	// canvas layer
	when ODIN_DEBUG {
		text, _ := reflect.enum_name_from_value(state.phase)
		draw_centered_text(text, 40)
	}
}

@(private = "file")
draw_pause :: proc() {
	draw_play()
	fill_screen(bg_overlay)
	draw_centered_text("Paused")
}

@(private = "file")
draw_game_over :: proc() {
	draw_play()
	fill_screen(bg_overlay)
	draw_centered_text("Game over")
}
