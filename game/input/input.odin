package input

import "core:c"
import "vendor:raylib"

Key :: raylib.KeyboardKey

Action :: enum {
	UP     = int(Key.K),
	DOWN   = int(Key.J),
	LEFT   = int(Key.H),
	RIGHT  = int(Key.L),
	SELECT = int(Key.ENTER),
	PAUSE  = int(Key.P),
	EXIT   = int(Key.ESCAPE),
}

// Returns the current action being pressed
get_pressed :: proc() -> Action {
	return Action(get_key_pressed())
}

// Returns the current key being pressed
get_key_pressed :: proc() -> Key {
	return raylib.GetKeyPressed()
}
