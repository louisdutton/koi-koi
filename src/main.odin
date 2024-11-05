package main

import rl "vendor:raylib"

SQUARE_SIZE             :: 20

GRID_HORIZONTAL_SIZE    :: 14
GRID_VERTICAL_SIZE      :: 20

LATERAL_SPEED           :: 10
TURNING_SPEED           :: 12
FAST_FALL_AWAIT_COUNTER :: 30

FADING_TIME             :: 33

SCREEN_WIDTH  :: 800
SCREEN_HEIGHT :: 450

UP :: rl.KeyboardKey.K
DOWN :: rl.KeyboardKey.J
LEFT :: rl.KeyboardKey.H
RIGHT :: rl.KeyboardKey.L

Grid_Square :: enum u8 {
	Empty,
	Moving,
	Full,
	Block,
	Fading,
}

GameState :: enum u8 {
	Play,
	Pause,
	GameOver,
}

game_over := false
state := GameState.Play

grid:           [GRID_HORIZONTAL_SIZE][GRID_VERTICAL_SIZE]Grid_Square
piece:          [4][4]Grid_Square
incoming_piece: [4][4]Grid_Square

piece_position: [2]i32

fading_color: rl.Color

begin_play := true
piece_active := false
detection := false
line_to_delete := false

level := 1
lines := 0

gravity_movement_counter := 0
lateral_movement_counter := 0
turn_movement_counter := 0
fast_fall_movement_counter := 0

fade_line_counter := 0

inverse_gravity_speed := 30

main :: proc() {
	rl.SetConfigFlags({ .WINDOW_RESIZABLE, .WINDOW_UNDECORATED })
	rl.SetTargetFPS(60)      
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Tetroid")
	defer rl.CloseWindow()   

	init()

	for !rl.WindowShouldClose() { // Detect window close button or ESC key
		update()
		draw()
	}
}

init :: proc() {
	level = 1
	lines = 0

	fading_color = rl.GRAY

	piece_position = {0, 0}

	begin_play     = true
	piece_active   = false
	detection      = false
	line_to_delete = false

	// Counters
	gravity_movement_counter = 0
	lateral_movement_counter = 0
	turn_movement_counter = 0
	fast_fall_movement_counter = 0

	fade_line_counter = 0
	inverse_gravity_speed = 30

	grid = {}
	incoming_piece = {}

	// Initialize grid matrices
	for i in 0..<GRID_HORIZONTAL_SIZE {
		for j in 0..<GRID_VERTICAL_SIZE {
			switch {
			case j == GRID_VERTICAL_SIZE - 1,
				i == GRID_HORIZONTAL_SIZE - 1,
				i == 0:
				grid[i][j] = .Block
			}
		}
	}
}

create_piece :: proc() -> bool {
	piece_position.x = (GRID_HORIZONTAL_SIZE - 4)/2
	piece_position.y = 0

	// If the game is starting and you are going to create the first piece, we create an extra one
	if (begin_play) {
		get_random_piece()
		begin_play = false
	}

	// We assign the incoming piece to the actual piece
	piece = incoming_piece

	// We assign a random piece to the incoming one
	get_random_piece()

	// Assign the piece to the grid
	for i in piece_position.x ..< piece_position.x+4 {
		for j in 0 ..< 4 {
			if piece[i - piece_position.x][j] == .Moving {
				grid[i][j] = .Moving
			}
		}
	}

	return true
}

get_random_piece :: proc() {
	random := rl.GetRandomValue(0, 6)

	incoming_piece = {}

	switch random {
	case 0: incoming_piece[1][1] = .Moving; incoming_piece[2][1] = .Moving; incoming_piece[1][2] = .Moving; incoming_piece[2][2] = .Moving //Cube
	case 1: incoming_piece[1][0] = .Moving; incoming_piece[1][1] = .Moving; incoming_piece[1][2] = .Moving; incoming_piece[2][2] = .Moving //L
	case 2: incoming_piece[1][2] = .Moving; incoming_piece[2][0] = .Moving; incoming_piece[2][1] = .Moving; incoming_piece[2][2] = .Moving //L inversa
	case 3: incoming_piece[0][1] = .Moving; incoming_piece[1][1] = .Moving; incoming_piece[2][1] = .Moving; incoming_piece[3][1] = .Moving //Recta
	case 4: incoming_piece[1][0] = .Moving; incoming_piece[1][1] = .Moving; incoming_piece[1][2] = .Moving; incoming_piece[2][1] = .Moving //Creu tallada
	case 5: incoming_piece[1][1] = .Moving; incoming_piece[2][1] = .Moving; incoming_piece[2][2] = .Moving; incoming_piece[3][2] = .Moving //S
	case 6: incoming_piece[1][2] = .Moving; incoming_piece[2][2] = .Moving; incoming_piece[2][1] = .Moving; incoming_piece[3][1] = .Moving //S inversa
	}
}

delete_complete_lines :: proc() {
	for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
		for grid[1][j] == .Fading {
			for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				grid[i][j] = .Empty
			}

			for j2 := j-1; j2 >= 0; j2 -= 1 {
				for i2 := 1; i2 < GRID_HORIZONTAL_SIZE-1; i2 += 1 {
					#partial switch grid[i2][j2] {
					case .Full:
						grid[i2][j2+1] = .Full
						grid[i2][j2] = .Empty
					case .Fading:
						grid[i2][j2+1] = .Fading
						grid[i2][j2] = .Empty
					}
				}
			}
		}

	}
}

check_detection :: proc(detection: ^bool) {
	for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
		for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
			if (grid[i][j] == .Moving) && ((grid[i][j+1] == .Full) || (grid[i][j+1] == .Block)) {
				detection^ = true
			}
		}
	}
}

resolve_falling_movement :: proc(detection: ^bool, piece_active: ^bool) {
	if detection^ {
		for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
			for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				if grid[i][j] == .Moving {
					grid[i][j] = .Full
					detection^ = false
					piece_active^ = false
				}
			}
		}
	} else {
		for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
			for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				if grid[i][j] == .Moving {
					grid[i][j+1] = .Moving
					grid[i][j] = .Empty
				}
			}
		}

		piece_position.y += 1
	}
}

check_completion :: proc(line_to_delete: ^bool) {
	for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
		calculator := 0
		for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
			if grid[i][j] == .Full {
				calculator += 1
			}

			if calculator == GRID_HORIZONTAL_SIZE-2 {
				line_to_delete^ = true
				calculator = 0

				for z in 1..<GRID_HORIZONTAL_SIZE-1 {
					grid[z][j] = .Fading
				}
			}
		}
	}
}

resolve_lateral_movement :: proc() -> (collision: bool) {
	switch {
	case rl.IsKeyDown(LEFT):
		left_collision_loop: for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
			for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				if grid[i][j] == .Moving {
					if i-1 == 0 || grid[i-1][j] == .Full {
						collision = true
						break left_collision_loop
					}
				}
			}
		}

		if !collision {
			for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
				for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
					if grid[i][j] == .Moving {
						if grid[i][j] == .Moving {
							grid[i-1][j] = .Moving
							grid[i][j] = .Empty
						}
					}
				}
			}

			piece_position.x -= 1
		}


	case rl.IsKeyDown(RIGHT):
		right_collision_loop: for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
			for i := 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				if grid[i][j] == .Moving {
					if i+1 == GRID_HORIZONTAL_SIZE-1 || grid[i+1][j] == .Full {
						collision = true
						break right_collision_loop
					}
				}
			}
		}


		if !collision {
			for j := GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
				for i := GRID_HORIZONTAL_SIZE-1; i >= 1; i -= 1 {
					if grid[i][j] == .Moving {
						if grid[i][j] == .Moving {
							grid[i+1][j] = .Moving
							grid[i][j] = .Empty
						}
					}
				}
			}


			piece_position.x += 1
		}

	}

	return
}

resolve_turn_movement :: proc() -> bool {
	// Input for turning the piece
	if rl.IsKeyDown(UP) {
		checker := false

		// Check all turning possibilities
		if ((grid[piece_position.x + 3][piece_position.y] == .Moving) &&
		    (grid[piece_position.x][piece_position.y] != .Empty) &&
		    (grid[piece_position.x][piece_position.y] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 3][piece_position.y + 3] == .Moving) &&
		           (grid[piece_position.x + 3][piece_position.y] != .Empty) &&
		           (grid[piece_position.x + 3][piece_position.y] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x][piece_position.y + 3] == .Moving) &&
		           (grid[piece_position.x + 3][piece_position.y + 3] != .Empty) &&
		           (grid[piece_position.x + 3][piece_position.y + 3] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x][piece_position.y] == .Moving) &&
		           (grid[piece_position.x][piece_position.y + 3] != .Empty) &&
		           (grid[piece_position.x][piece_position.y + 3] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 1][piece_position.y] == .Moving) &&
		           (grid[piece_position.x][piece_position.y + 2] != .Empty) &&
		           (grid[piece_position.x][piece_position.y + 2] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 3][piece_position.y + 1] == .Moving) &&
		           (grid[piece_position.x + 1][piece_position.y] != .Empty) &&
		           (grid[piece_position.x + 1][piece_position.y] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 2][piece_position.y + 3] == .Moving) &&
		           (grid[piece_position.x + 3][piece_position.y + 1] != .Empty) &&
		           (grid[piece_position.x + 3][piece_position.y + 1] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x][piece_position.y + 2] == .Moving) &&
		           (grid[piece_position.x + 2][piece_position.y + 3] != .Empty) &&
		           (grid[piece_position.x + 2][piece_position.y + 3] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 2][piece_position.y] == .Moving) &&
		           (grid[piece_position.x][piece_position.y + 1] != .Empty) &&
		           (grid[piece_position.x][piece_position.y + 1] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 3][piece_position.y + 2] == .Moving) &&
		           (grid[piece_position.x + 2][piece_position.y] != .Empty) &&
		           (grid[piece_position.x + 2][piece_position.y] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 1][piece_position.y + 3] == .Moving) &&
		           (grid[piece_position.x + 3][piece_position.y + 2] != .Empty) &&
		           (grid[piece_position.x + 3][piece_position.y + 2] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x][piece_position.y + 1] == .Moving) &&
		           (grid[piece_position.x + 1][piece_position.y + 3] != .Empty) &&
		           (grid[piece_position.x + 1][piece_position.y + 3] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 1][piece_position.y + 1] == .Moving) &&
		           (grid[piece_position.x + 1][piece_position.y + 2] != .Empty) &&
		           (grid[piece_position.x + 1][piece_position.y + 2] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 2][piece_position.y + 1] == .Moving) &&
		           (grid[piece_position.x + 1][piece_position.y + 1] != .Empty) &&
		           (grid[piece_position.x + 1][piece_position.y + 1] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 2][piece_position.y + 2] == .Moving) &&
		           (grid[piece_position.x + 2][piece_position.y + 1] != .Empty) &&
		           (grid[piece_position.x + 2][piece_position.y + 1] != .Moving)) {
			checker = true
		} else if ((grid[piece_position.x + 1][piece_position.y + 2] == .Moving) &&
		           (grid[piece_position.x + 2][piece_position.y + 2] != .Empty) &&
		           (grid[piece_position.x + 2][piece_position.y + 2] != .Moving)) {
			checker = true
		}

		if !checker {
			piece[0][0], piece[3][0], piece[3][3], piece[0][3] = \
			piece[3][0], piece[3][3], piece[0][3], piece[0][0]
			
			piece[1][0], piece[3][1], piece[2][3], piece[0][2] = \
			piece[3][1], piece[2][3], piece[0][2], piece[1][0]

			piece[2][0], piece[3][2], piece[1][3], piece[0][1] = \
			piece[3][2], piece[1][3], piece[0][1], piece[2][0]
			
			piece[1][1], piece[2][1], piece[2][2], piece[1][2] = \
			piece[2][1], piece[2][2], piece[1][2], piece[1][1]
		}

		for j: i32 = GRID_VERTICAL_SIZE-2; j >= 0; j -= 1 {
			for i: i32 = 1; i < GRID_HORIZONTAL_SIZE-1; i += 1 {
				if grid[i][j] == .Moving {
					grid[i][j] = .Empty
				}
			}
		}

		for i in i32(0)..<4 {
			for j in i32(0)..<4 {
				if piece[i][j] == .Moving {
					grid[piece_position.x+i][piece_position.y+j] = .Moving
				}
			}
		}

		return true
	}

	return false
}
