package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "vendor:raylib"

load :: proc() {
	load_window()
	load_images()
	load_state()

	// populate and shuffle deck
	for i in 0 ..< DECK_SIZE {state.deck[i] = u8(i)}
	rand.shuffle(state.deck[:])

	// deal
	deal()

	if hand_is_instant_win(&state.player.hand) {
		fmt.println("You win!")
		os.exit(0)
	}

	if hand_is_instant_win(&state.opponent.hand) {
		fmt.println("Opponent wins!")
		os.exit(0)
	}
}

@(private = "file")
load_state :: proc() {
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
}

// the number of cards dealt before moving on to the next recipient
DEAL_INSTALLMENT_SIZE :: HAND_SIZE / 4

// Deals cards in installments (opponent -> table -> player)
@(private = "file")
deal :: proc() {
	for i in 0 ..< HAND_SIZE / DEAL_INSTALLMENT_SIZE {
		recipients := [3]^[dynamic]Card{&state.opponent.hand, &state.table, &state.player.hand}
		for r in recipients {
			for i in 0 ..< DEAL_INSTALLMENT_SIZE {
				append(r, pop(&state.deck))
			}
		}
	}
}

@(private = "file")
load_window :: proc() {
	raylib.SetConfigFlags({.WINDOW_RESIZABLE, .WINDOW_UNDECORATED})
	raylib.SetTargetFPS(FPS)
	raylib.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, TITLE)
}
