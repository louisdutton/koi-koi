package main

import m "core:math"
import r "vendor:raylib"

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

UP :: r.KeyboardKey.K
DOWN :: r.KeyboardKey.J
LEFT :: r.KeyboardKey.H
RIGHT :: r.KeyboardKey.L

FPS :: 60

GameState :: enum u8 {
	Play,
	Pause,
	GameOver,
}

state := GameState.Play

main :: proc() {
	r.SetConfigFlags({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	r.SetTargetFPS(FPS)

	r.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Koi-Koi")
	defer r.CloseWindow()

	for !r.WindowShouldClose() { 	// Detect window close button or ESC key
		update()
		draw()
	}
}
