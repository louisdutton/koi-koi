package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import r "vendor:raylib"

// card counts
HAND_SIZE :: 8
TABLE_MAX :: HAND_SIZE * 2
MONTH_SIZE :: 4
MONTH_COUNT :: 12
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

Card :: u8

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
	OpponentTable,
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

init :: proc() {
	state = GameState {
		scene = .Play,
		phase = .PlayerHand,

		// selection
		hand_index = 0,
		table_index = 0,

		// collections
		deck = make([dynamic]Card, DECK_SIZE, DECK_SIZE),
		table = make([dynamic]Card, 0, TABLE_MAX),

		// players
		player = Player {
			hand = make([dynamic]Card, 0, HAND_SIZE),
			collection = make([dynamic]Card, 0, DECK_SIZE),
		},
		opponent = Player {
			hand = make([dynamic]Card, 0, HAND_SIZE),
			collection = make([dynamic]Card, 0, DECK_SIZE),
		},
	}

	// populate and shuffle deck
	for i in 0 ..< DECK_SIZE {state.deck[i] = u8(i)}
	rand.shuffle(state.deck[:])

	// deal
	for i in 0 ..< 4 {
		// 2 to opponent
		append(&state.opponent.hand, pop(&state.deck))
		append(&state.opponent.hand, pop(&state.deck))

		// 2 to table
		append(&state.table, pop(&state.deck))
		append(&state.table, pop(&state.deck))

		append(&state.player.hand, pop(&state.deck))
		append(&state.player.hand, pop(&state.deck))
	}

	if is_instant_win(&state.player.hand) {
		fmt.println("You win!")
		os.exit(0)
	}
}

// free all dynamic collections in game state
shutdown :: proc() {
	delete(state.matches)

	delete(state.deck)
	delete(state.table)

	delete(state.player.collection)
	delete(state.player.hand)

	delete(state.opponent.hand)
	delete(state.opponent.collection)
}
