package main

import "core:math/rand"

ai_play :: proc() {
	// check if any matches are possible
	options := make([dynamic][dynamic]TableIndex)
	defer delete(options)
	for card in opponent {
		matches := get_matches(card)
		if len(matches) > 0 {
			append(&options, matches)
		}
	}

	option_count := len(options)
	if option_count > 0 {
		// pick a random card from the hand
		hand_index := rand.int_max(option_count)
		// and a random card from the table
		table_index := rand.int_max(len(options[hand_index]))

		// perform match
		defer ordered_remove(&table, table_index)
		defer unordered_remove(&opponent, hand_index)

		// end turn
		play_state = .Choose_Hand
	} else {
		// no matches available so add a random card to the table
		to_remove := rand.int_max(len(opponent))
		append(&table, opponent[to_remove])
		unordered_remove(&opponent, to_remove)
	}
}
