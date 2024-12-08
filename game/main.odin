package main

import m "core:math"
import r "vendor:raylib"

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
