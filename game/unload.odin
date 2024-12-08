package main

import "vendor:raylib"

unload :: proc() {
	unload_state()
	unload_images()
	unload_window()
}
