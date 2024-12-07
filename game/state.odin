package main

// card counts
HAND_SIZE :: 8
TABLE_MAX :: HAND_SIZE * 2
MONTH_SIZE :: 4
MONTH_COUNT :: 12
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

Player :: struct {
	hand:       [dynamic]Card,
	collection: [dynamic]Card,
}

Scene :: enum u8 {
	Play,
	Pause,
	GameOver,
}

Phase :: enum u8 {
	PlayerHand,
	PlayerTable,
	Flip,
	OpponentHand,
}

GameState :: struct {
	// state
	scene:       Scene,
	phase:       Phase,

	// selection
	hand_index:  int,
	table_index: int,

	// buffers
	matches:     [dynamic]int, // table indices
	flip_card:   Card,

	// collections
	deck:        [dynamic]Card,
	table:       [dynamic]Card,

	// players
	player:      Player,
	opponent:    Player,
}

state: GameState
