package main

import "core:testing"

// Returns true if a hand has been dealt an instant win.
// An instant win occurs when a player is dealt either 4 of a kind or 4 pairs.
hand_is_instant_win :: proc(hand: []CardEntity) -> bool {
	assert(
		len(hand) == HAND_SIZE,
		"this function should only be called immediately after the cards are dealt",
	)

	// group cards by month
	groups: map[Suit]int
	defer delete(groups)
	for card in hand do groups[card_get_suit(card.card)] += 1

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
	hand := create_hand({.Stalk, .JanScroll, .JanA, .JanB, .FebSeed, .FebScroll, .FebA, .FebB})
	testing.expect(t, hand_is_instant_win(hand[:]))
}

@(test)
test_four_pair :: proc(t: ^testing.T) {
	hand := create_hand({.Stalk, .JanScroll, .FebA, .FebB, .MarA, .MarB, .AprA, .AprB})
	testing.expect(t, hand_is_instant_win(hand[:]))
}

@(private = "file")
create_hand :: proc(cards: [8]Card) -> (hand: [8]CardEntity) {
	for card, i in cards {
		hand[i] = {
			card = card,
		}
	}
	return
}
