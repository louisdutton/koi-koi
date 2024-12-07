package input

import "core:c"
import "vendor:raylib"

Action :: enum {
	UP     = int(raylib.KeyboardKey.K),
	DOWN   = int(raylib.KeyboardKey.J),
	LEFT   = int(raylib.KeyboardKey.H),
	RIGHT  = int(raylib.KeyboardKey.L),
	SELECT = int(raylib.KeyboardKey.ENTER),
	PAUSE  = int(raylib.KeyboardKey.P),
	EXIT   = int(raylib.KeyboardKey.ESCAPE),
}

get_pressed :: proc() -> Action {
	return Action(raylib.GetKeyPressed())
}
