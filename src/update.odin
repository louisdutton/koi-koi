package main

import rl "vendor:raylib"

update_play :: proc() {
	if rl.IsKeyPressed(.P) {
		state = .Pause
		return
	}

	if line_to_delete {
		fade_line_counter += 1

		if fade_line_counter % 8 < 4 {
			fading_color = rl.MAROON
		} else {
			fading_color = rl.GRAY
		}

		if fade_line_counter >= FADING_TIME {
			delete_complete_lines()
			fade_line_counter = 0
			line_to_delete = false

			lines += 1
		}
		return
	}


	if !piece_active {
		piece_active = create_piece()
		fast_fall_movement_counter = 0
	} else {
		fast_fall_movement_counter += 1
		gravity_movement_counter   += 1
		lateral_movement_counter   += 1
		turn_movement_counter      += 1

		// We make sure to move if we've pressed the key this frame
		if rl.IsKeyPressed(LEFT) || rl.IsKeyPressed(RIGHT) {
			lateral_movement_counter = LATERAL_SPEED
		}
		if rl.IsKeyPressed(UP) {
			turn_movement_counter = TURNING_SPEED
		}

		// Fall down
		if rl.IsKeyDown(DOWN) && fast_fall_movement_counter >= FAST_FALL_AWAIT_COUNTER {
			// We make sure the piece is going to fall this frame
			gravity_movement_counter += inverse_gravity_speed
		}

		if gravity_movement_counter >= inverse_gravity_speed {
			// Basic falling movement
			check_detection(&detection)

			// Check if the piece has collided with another piece or with the boundings
			resolve_falling_movement(&detection, &piece_active)

			// Check if we fullfilled a line and if so, erase the line and pull down the the lines above
			check_completion(&line_to_delete)

			gravity_movement_counter = 0
		}

		// Move laterally at player's will
		if lateral_movement_counter >= LATERAL_SPEED {
			// Update the lateral movement and if success, reset the lateral counter
			if !resolve_lateral_movement() {
				lateral_movement_counter = 0
			}
		}

		// Turn the piece at player's will
		if turn_movement_counter >= TURNING_SPEED {
			// Update the turning movement and reset the turning counter
			if resolve_turn_movement() {
				turn_movement_counter = 0
			}
		}

		for j in 0..<2 {
			for i in 1..<GRID_HORIZONTAL_SIZE-1 {
				if grid[i][j] == .Full {
					state = .GameOver
				}
			}
		}
	}
}

update :: proc() {
	switch state {
	case .Play: update_play()	
	case .GameOver:
		if rl.IsKeyPressed(.ENTER) {
			init()
			state = .Play
		}

	case .Pause:
		if rl.IsKeyPressed(.P) {
			state = .Play
		}

	}
}
