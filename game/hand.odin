package main

import "core:fmt"
import "core:math"
import "core:testing"

// play a card from your hand.
// optionally, match with a card on the table, adding both of them to your collection
hand_play :: proc(player: ^Player, hand_index: int, table_index: Maybe(int) = nil) {
	when ODIN_DEBUG {
		fmt.println(
			"play",
			state.phase,
			card_get_suit(player.hand[hand_index]), // fmt
		)
	}

	if index, ok := table_index.(int); ok {
		// add card to collection (twice)
		append(&player.collection, player.hand[hand_index])
		append(&player.collection, state.table[index])

		// remove from table
		ordered_remove(&state.table, index)
		state.table_index = 0
	}

	// remove from hand
	ordered_remove(&player.hand, hand_index)
	state.hand_index = 0

	// trigger next phase of the turn
	start_flip(player)
}


// Returns true if a hand has been dealt an instant win.
// An instant win occurs when a player is dealt either 4 of a kind or 4 pairs.
hand_is_instant_win :: proc(hand: ^[dynamic]Card) -> bool {
	assert(
		len(hand) == HAND_SIZE,
		"this function should only be called immediately after the cards are dealt",
	)

	// group cards by month
	groups: map[u8]int
	defer delete(groups)
	for card in hand {
		key := card / MONTH_SIZE
		groups[key] += 1
	}

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
	hand := [dynamic]Card{0, 1, 2, 3, 4, 5, 6, 7}
	defer delete(hand)
	testing.expect(t, hand_is_instant_win(&hand) == true)
}

@(test)
test_four_pair :: proc(t: ^testing.T) {
	hand := [dynamic]Card{0, 1, 4, 5, 8, 9, 12, 13}
	defer delete(hand)
	testing.expect(t, hand_is_instant_win(&hand) == true)
}
