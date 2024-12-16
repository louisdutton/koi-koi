package main

import "core:log"
import "core:math"
import "timing"
import "vendor:raylib"

LOGGER_OPTS := log.Options{.Level, .Terminal_Color}

main :: proc() {
	// logger
	when ODIN_DEBUG {
		logger := log.create_console_logger(.Debug, LOGGER_OPTS)
	} else {
		logger := log.create_console_logger(.Info, LOGGER_OPTS)
	}
	context.logger = logger
	defer log.destroy_console_logger(context.logger)

	// setup / teardown
	load()
	defer unload()

	// life-cycle
	for !should_exit() {
		delta := timing.get_delta()
		elapsed := timing.get_elapsed()
		update(delta, elapsed)
		draw(delta)
	}
}

// Detect window close button or ESC key
should_exit :: proc() -> bool {
	return raylib.WindowShouldClose()
}
