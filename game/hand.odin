package main

import "core:log"
import "core:math"
import "core:testing"

// play a card from your hand.
// optionally, match with a card on the table, adding both of them to your collection
hand_play :: proc(player: ^Player, hand_index: int, table_index: Maybe(int) = nil) {
	if index, ok := table_index.(int); ok {
		log.debug("match", state.phase, player.hand[hand_index], state.table[index])
		// add card to collection (twice)
		append(&player.collection, player.hand[hand_index])
		append(&player.collection, state.table[index])

		// remove from table
		ordered_remove(&state.table, index)
		state.table_index = 0
	} else {
		log.debug("play", state.phase, player.hand[hand_index])
	}

	// remove from hand
	ordered_remove(&player.hand, hand_index)
	state.hand_index = 0

	// trigger next phase of the turn
	start_flip(player)
}


// Returns true if a hand has been dealt an instant win.
// An instant win occurs when a player is dealt either 4 of a kind or 4 pairs.
hand_is_instant_win :: proc(hand: []Card) -> bool {
	assert(
		len(hand) == HAND_SIZE,
		"this function should only be called immediately after the cards are dealt",
	)

	// group cards by month
	groups: map[Suit]int
	defer delete(groups)
	for card in hand do groups[card_get_suit(card)] += 1

	pair_count := 0
	for _, v in groups {
		switch v {
		// 4 of a kind
		case 4:
			return true
		case 2:
			pair_count += 1
			// 4 pairs
			if (pair_count == 4) {return true}
		}
	}

	return false
}

@(test)
test_four_of_a_kind :: proc(t: ^testing.T) {
	hand := []Card{.Jan0, .Jan1, .Jan2, .Jan3, .Feb0, .Feb1, .Feb2, .Feb3}
	testing.expect(t, hand_is_instant_win(hand))
}

@(test)
test_four_pair :: proc(t: ^testing.T) {
	hand := []Card{.Jan0, .Jan1, .Feb0, .Feb1, .Mar0, .Mar1, .Apr0, .Apr1}
	testing.expect(t, hand_is_instant_win(hand))
}
