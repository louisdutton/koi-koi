package main

// the maximum number of cards allowed in the hand
HAND_SIZE :: 8
// the maximum number of cards allowed on the table
TABLE_MAX :: HAND_SIZE * 2
// the number of cards per month
MONTH_SIZE :: 4
// the number of months
MONTH_COUNT :: 12
// the number of cards in the deck
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

Player :: struct {
	hand:       [dynamic]CardEntity,
	collection: [dynamic]CardEntity,
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
	flip_card:   CardEntity,

	// collections
	deck:        [dynamic]CardEntity,
	table:       [dynamic]CardEntity,

	// players
	player:      Player,
	opponent:    Player,

	// time
	elapsed:     f64,
	delta:       f32,
}

state: GameState

load_state :: proc() {
	state = GameState {
		scene = .Play,
		phase = .PlayerHand,

		// selection
		hand_index = 0,
		table_index = 0,

		// collections
		deck = make([dynamic]CardEntity, DECK_SIZE, DECK_SIZE),
		table = make([dynamic]CardEntity, 0, TABLE_MAX),

		// players
		player = Player {
			hand = make([dynamic]CardEntity, 0, HAND_SIZE),
			collection = make([dynamic]CardEntity, 0, DECK_SIZE),
		},
		opponent = Player {
			hand = make([dynamic]CardEntity, 0, HAND_SIZE),
			collection = make([dynamic]CardEntity, 0, DECK_SIZE),
		},
	}
}

unload_state :: proc() {
	delete(state.matches)

	delete(state.deck)
	delete(state.table)

	delete(state.player.collection)
	delete(state.player.hand)

	delete(state.opponent.hand)
	delete(state.opponent.collection)
}
