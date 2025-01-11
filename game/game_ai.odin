package main

import "core:math/rand"

// returns the index of the chosen card to be played
ai_play :: proc(hand: []CardEntity) -> (hand_index: int, table_index: Maybe(int)) {
	card_count := len(hand)

	if (card_count == 0) {
		panic("hand should never be empty")
	}

	// check if any matches are possible
	options := ai_calc_options()
	defer delete(options)

	option_count := len(options)
	if option_count > 0 {
		table_option_count := len(options[hand_index])
		// pick a random card from the hand
		hand_index = rand.int_max(option_count)
		// and a random card from the table
		table_index = rand.int_max(table_option_count)
		return hand_index, table_index
	} else {
		// no matches available so add a random card to the table
		return rand.int_max(card_count), nil
	}
}

ai_calc_options :: proc() -> [dynamic][dynamic]int {
	options := make([dynamic][dynamic]int)
	for card in state.opponent.hand {
		matches := get_matches(card.card, state.table[:])
		if len(state.matches) > 0 {
			append(&options, state.matches)
		}
	}
	return options
}

ai_choose_match :: proc(matches: []int) -> int {
	return rand.choice(matches)
}
