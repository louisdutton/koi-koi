package engine

import "vendor:raylib"

should_exit :: proc() -> bool {
	return raylib.WindowShouldClose()
}
