package main

import "core:fmt"
import "core:testing"

// Returns true if a hand has been dealt an instant win.
// An instant win occurs when a player is dealt either 4 of a kind or 4 pairs.
is_instant_win :: proc(hand: ^[dynamic]Card) -> bool {
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
	testing.expect(t, is_instant_win(&hand) == true)
}

@(test)
test_four_pair :: proc(t: ^testing.T) {
	hand := [dynamic]Card{0, 1, 4, 5, 8, 9, 12, 13}
	defer delete(hand)
	testing.expect(t, is_instant_win(&hand) == true)
}
