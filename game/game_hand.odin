package main

import "core:testing"

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
