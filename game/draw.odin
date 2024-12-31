package main

import "core:fmt"
import "core:reflect"
import "core:strings"
import "vendor:raylib"

PADDING :: 10
FONT_SIZE :: 40
TEXT_COLOUR :: raylib.WHITE
FONT_CENTER_VERTICAL :: SCREEN_HEIGHT / 2 - FONT_SIZE / 2

draw :: proc(dt: f32) {
	raylib.BeginDrawing()
	defer raylib.EndDrawing()

	raylib.ClearBackground(raylib.GRAY)

	switch state.scene {
	case .Play:
		draw_play()
	case .Pause:
		draw_pause()
	case .GameOver:
		draw_pause()
	}
}

draw_play :: proc() {
	// collection
	draw_deck()

	// individual cards
	entities := prepare_entities()
	entity_count :=
		len(state.player.hand) +
		len(state.player.collection) +
		len(state.opponent.hand) +
		len(state.opponent.collection) +
		len(state.table)
	for card, i in entities[:entity_count] {
		draw_card(card)
	}

	// canvas layer
	draw_ui()
}

draw_ui :: proc() {
	when ODIN_DEBUG {
		text, _ := reflect.enum_name_from_value(state.phase)
		ctext := strings.clone_to_cstring(text)
		defer delete(ctext)
		draw_centered_text(ctext, 40)
	}
}

draw_pause :: proc() {
	draw_play()
	fill_screen(raylib.Fade(raylib.BLACK, 0.75))
	draw_centered_text("Paused")
}

fill_screen :: proc(color: Color) {
	raylib.DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, color)
}

draw_centered_text :: proc(text: cstring, y: i32 = FONT_CENTER_VERTICAL) {
	w := raylib.MeasureText(text, FONT_SIZE)
	raylib.DrawText(text, SCREEN_WIDTH / 2 - w / 2, y, FONT_SIZE, TEXT_COLOUR)
}
