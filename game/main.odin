package main

import m "core:math"
import r "vendor:raylib"

TITLE :: "Koi-Koi"
SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

FPS :: 60

main :: proc() {
	load()
	defer unload()

	for !should_exit() {
		r.GetTime()
		update()
		draw()
	}
}

// Detect window close button or ESC key
should_exit :: proc() -> bool {
	return r.WindowShouldClose()
}
