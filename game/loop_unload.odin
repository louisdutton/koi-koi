package main

import "vendor:raylib"

unload :: proc() {
	unload_state()
	unload_textures()
	unload_window()
}
