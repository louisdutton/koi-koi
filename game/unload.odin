package main

import "vendor:raylib"

unload :: proc() {
  unload_state()
	unload_images()
  unload_window()
}

@(private)
unload_state:: proc() {
	delete(state.matches)

	delete(state.deck)
	delete(state.table)

	delete(state.player.collection)
	delete(state.player.hand)

	delete(state.opponent.hand)
	delete(state.opponent.collection)
}


@(private)
unload_window:: proc() {
	raylib.CloseWindow()
}
