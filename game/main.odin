package main

import "audio"
import "core:log"
import "core:math"
import "engine"
import "vendor:raylib"

main :: proc() {
	// logger assigned to global context
	context.logger = create_logger()
	defer log.destroy_console_logger(context.logger)

	// setup / teardown
	load()
	defer unload()

	// start music
	audio.music_set_volume(0.2)
	audio.music_play()

	// life-cycle
	for !should_exit() {
		state.delta = engine.get_delta()
		state.elapsed = engine.get_elapsed()
		update()
		draw()
	}
}

should_exit :: proc() -> bool {
	return raylib.WindowShouldClose()
}

