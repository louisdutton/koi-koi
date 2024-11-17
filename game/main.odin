package main

import m "core:math"
import r "vendor:raylib"

TITLE :: "Koi-Koi"
SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

FPS :: 60


main :: proc() {
	r.SetConfigFlags({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	r.SetTargetFPS(FPS)

	r.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, TITLE)
	defer r.CloseWindow()

	init()

	for !r.WindowShouldClose() { 	// Detect window close button or ESC key
		r.GetTime()
		update()
		draw()
	}

	shutdown()
}
