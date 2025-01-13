package main

import "core:log"

LOGGER_OPTS := log.Options{.Level, .Terminal_Color}

create_logger :: proc() -> log.Logger {
	when ODIN_DEBUG {
		return log.create_console_logger(.Debug, LOGGER_OPTS)
	} else {
		return log.create_console_logger(.Info, LOGGER_OPTS)
	}
}
