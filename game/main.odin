package main

import "core:log"
import "core:math"
import "vendor:raylib"

LOGGER_OPTS := log.Options{.Level, .Terminal_Color}

main :: proc() {
	when ODIN_DEBUG {
		logger := log.create_console_logger(.Debug, LOGGER_OPTS)
	} else {
		logger := log.create_console_logger(.Info, LOGGER_OPTS)
	}
	context.logger = logger

	load()
	defer unload()

	for !should_exit() {
		raylib.GetTime()
		update()
		draw()
	}

	log.destroy_console_logger(context.logger)
}

// Detect window close button or ESC key
should_exit :: proc() -> bool {
	return raylib.WindowShouldClose()
}
