package timing

import "vendor:raylib"

// Returns elapsed time in seconds since the window was initialised
get_elapsed :: proc() -> f64 {
	return raylib.GetTime()
}

// Returns time in seconds for last frame drawn
get_delta :: proc() -> f32 {
	return raylib.GetFrameTime()
}
