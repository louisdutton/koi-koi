package main

import "color"
import "core:strings"
import "vendor:raylib"

// Draws a rect that fills the entire screen
fill_screen :: proc(color: color.Color) {
	raylib.DrawRectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, color)
}

// Draws a rect that fills the entire screen
clear_screen :: proc(color: color.Color) {
	raylib.ClearBackground(color)
}

// Draws a string in the middle of the screen
draw_centered_text :: proc(text: string, y: i32 = FONT_CENTER_VERTICAL) {
	ctext := strings.clone_to_cstring(text)
	defer delete(ctext)
	w := raylib.MeasureText(ctext, FONT_SIZE)
	raylib.DrawText(ctext, SCREEN_WIDTH / 2 - w / 2, y, FONT_SIZE, TEXT_COLOUR)
}

// Opens the rendering batch
draw_start :: proc() {
	raylib.BeginDrawing()
}

// Closes the rendering batch
draw_end :: proc() {
	raylib.EndDrawing()
}
