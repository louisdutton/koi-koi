package main

import "core:math/rand"

ai_play :: proc() {
	card_count := len(state.opponent.hand)

	if (card_count == 0) {
		ai_end_turn()
		return
	}

	// check if any matches are possible
	options := ai_calc_options()
	defer delete(options)

	option_count := len(options)
	if option_count > 0 {
		// pick a random card from the hand
		hand_index := rand.int_max(option_count)
		// and a random card from the table
		table_option_count := len(options[hand_index])
		table_index := rand.int_max(table_option_count)

		// perform match
		ordered_remove(&state.table, table_index)
		unordered_remove(&state.opponent.hand, hand_index)

		ai_end_turn()
	} else {
		// no matches available so add a random card to the table
		to_remove := rand.int_max(card_count)
		append(&state.table, state.opponent.hand[to_remove])
		unordered_remove(&state.opponent.hand, to_remove)
	}
}

// end turn
ai_end_turn :: proc() {
	state.phase = .PlayerHand
}

ai_calc_options :: proc() -> [dynamic][dynamic]int {
	options := make([dynamic][dynamic]int)
	for card in state.opponent.hand {
		get_matches(card)
		if len(state.matches) > 0 {
			append(&options, state.matches)
		}
	}
	return options
}
