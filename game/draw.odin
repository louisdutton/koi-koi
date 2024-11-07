package main

import r "vendor:raylib"

PADDING :: 10

draw :: proc() {
	r.BeginDrawing()
	defer r.EndDrawing()

	r.ClearBackground(r.GRAY)

	#partial switch state {
	case .Play:
		draw_play()
	}
}

draw_play :: proc() {
	draw_player_hand()
	draw_opponent_hand()
}
