package main

import "vendor:raylib"

TITLE :: "Koi-Koi"
SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800
FPS :: 60

load_window :: proc() {
	raylib.SetConfigFlags({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	raylib.SetTargetFPS(FPS)
	raylib.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, TITLE)
}

unload_window :: proc() {
	raylib.CloseWindow()
}
