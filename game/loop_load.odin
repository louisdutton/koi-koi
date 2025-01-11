package main

import "core:log"
import "core:math/rand"
import "core:os"
import "vendor:raylib"

load :: proc() {
	load_window()
	load_textures()
	load_state()

	// populate and shuffle deck
	for i in 0 ..< DECK_SIZE {state.deck[i] = Card(i)}
	rand.shuffle(state.deck[:])

	// deal
	deal()

	switch {
	case hand_is_instant_win(state.player.hand[:]):
		win()
	case hand_is_instant_win(state.opponent.hand[:]):
		lose()
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

win :: proc() {
	log.debug("You win!")
	set_scene(.GameOver)
}

lose :: proc() {
	log.debug("Opponent wins!")
	set_scene(.GameOver)
}
