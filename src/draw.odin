package main

import rl "vendor:raylib"

draw_play :: proc() {
	offset := [2]i32{
		SCREEN_WIDTH/2 - (GRID_HORIZONTAL_SIZE*SQUARE_SIZE/2) - 50,
		SCREEN_HEIGHT/2 - ((GRID_VERTICAL_SIZE-1)*SQUARE_SIZE/2) + SQUARE_SIZE*2,
	}

	offset.y -= 50

	controller := offset.x

	for j in 0..<GRID_VERTICAL_SIZE {
		for i in 0..<GRID_HORIZONTAL_SIZE {
			switch grid[i][j] {
			case .Empty:
				rl.DrawLine(offset.x, offset.y, offset.x + SQUARE_SIZE, offset.y, rl.LIGHTGRAY)
				rl.DrawLine(offset.x, offset.y, offset.x, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
				rl.DrawLine(offset.x + SQUARE_SIZE, offset.y, offset.x + SQUARE_SIZE, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
				rl.DrawLine(offset.x, offset.y + SQUARE_SIZE, offset.x + SQUARE_SIZE, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
			case .Full:
				rl.DrawRectangle(offset.x, offset.y, SQUARE_SIZE, SQUARE_SIZE, rl.GRAY)
			case .Moving:
				rl.DrawRectangle(offset.x, offset.y, SQUARE_SIZE, SQUARE_SIZE, rl.DARKGRAY)
			case .Block:
				rl.DrawRectangle(offset.x, offset.y, SQUARE_SIZE, SQUARE_SIZE, rl.LIGHTGRAY)
			case .Fading:
				rl.DrawRectangle(offset.x, offset.y, SQUARE_SIZE, SQUARE_SIZE, fading_color)
			}
			offset.x += SQUARE_SIZE
		}

		offset.x = controller
		offset.y += SQUARE_SIZE
	}

	offset = {500, 45}

	controller = offset.x

	for j in 0..<4 {
		for i in 0..<4 {
			#partial switch incoming_piece[i][j] {
			case .Empty:
				rl.DrawLine(offset.x, offset.y, offset.x + SQUARE_SIZE, offset.y, rl.LIGHTGRAY)
				rl.DrawLine(offset.x, offset.y, offset.x, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
				rl.DrawLine(offset.x + SQUARE_SIZE, offset.y, offset.x + SQUARE_SIZE, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
				rl.DrawLine(offset.x, offset.y + SQUARE_SIZE, offset.x + SQUARE_SIZE, offset.y + SQUARE_SIZE, rl.LIGHTGRAY)
				offset.x += SQUARE_SIZE
			case .Moving:
				rl.DrawRectangle(offset.x, offset.y, SQUARE_SIZE, SQUARE_SIZE, rl.GRAY)
				offset.x += SQUARE_SIZE
			}
		}

		offset.x = controller
		offset.y += SQUARE_SIZE
	}

	rl.DrawText("INCOMING:", offset.x, offset.y - 100, 10, rl.GRAY)
	rl.DrawText(rl.TextFormat("LINES:      %04i", lines), offset.x, offset.y + 20, 10, rl.GRAY)
}

draw :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()

	rl.ClearBackground(rl.RAYWHITE)

	switch state {
	case .GameOver: draw_game_over()
	case .Play: draw_play()
	case .Pause:
		draw_play()
		draw_pause()
	}
}

draw_game_over :: proc() {
	text :: "PRESS [ENTER] TO PLAY AGAIN"
	rl.DrawText(text, rl.GetScreenWidth()/2 - rl.MeasureText(text, 20)/2, rl.GetScreenHeight()/2 - 50, 20, rl.GRAY)
}

draw_pause :: proc() {
	text :: "GAME PAUSED"
	rl.DrawText(text, SCREEN_WIDTH/2 - rl.MeasureText(text, 40)/2, SCREEN_WIDTH/2 - 40, 40, rl.GRAY)
}
