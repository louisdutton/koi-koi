package main

import "core:math/rand"

ai_play :: proc() {
	card_count := len(opponent.hand)

	if (card_count == 0) {
		play_state = .Choose_Hand
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
		ordered_remove(&table, table_index)
		unordered_remove(&opponent.hand, hand_index)

		// end turn
		play_state = .Choose_Hand
	} else {
		// no matches available so add a random card to the table
		to_remove := rand.int_max(card_count)
		append(&table, opponent.hand[to_remove])
		unordered_remove(&opponent.hand, to_remove)
	}
}

ai_calc_options :: proc() -> [dynamic][dynamic]TableIndex {
	options := make([dynamic][dynamic]TableIndex)
	for card in opponent.hand {
		matches := get_matches(card)
		if len(matches) > 0 {
			append(&options, matches)
		}
	}
	return options
}
