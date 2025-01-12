package main

import "core:log"

start_flip :: proc(player: ^Player) {
	state.flip_card = pop(&state.deck)
	state.matches = get_matches(state.flip_card.card, state.table[:])
	switch len(state.matches) {
	// can't match so add it to the table and end turn
	case 0:
		flip_play()

	// only one match so immediately apply match 
	case 1:
		flip_match(player, state.matches[0])

	// choose from multiple potential matches
	case:
		if state.phase == .OpponentHand {
			// ai autoselect
			flip_match(player, ai_choose_match(state.matches[:]))
		} else {
			// manual select
			set_phase(.Flip)
		}
	}
}

end_turn :: proc() {
	#partial switch state.phase {
	case .PlayerHand, .PlayerTable, .Flip:
		if collection_has_yaku(state.player.collection[:]) {
			win()
		}
		set_phase(.OpponentHand)
	case .OpponentHand:
		if collection_has_yaku(state.opponent.collection[:]) {
			lose()
		}
		set_phase(.PlayerHand)
	case:
		log.panicf("can't end turn from phase %e", state.phase)
	}
}

// play the flipped card onto the table without matching
// ends the current turn on completion
flip_play :: proc() {
	log.debug(state.phase, "flip-play", state.flip_card.card)
	animate_card(state.flip_card, TABLE_ANCHOR)
	append(&state.table, state.flip_card)
	end_turn()
}

// match the flipped card with a card on the table
// ends the current turn on completion
flip_match :: proc(player: ^Player, target_index: int) {
	table_card := state.table[target_index]
	log.debug(state.phase, "flip-match", [2]Card{state.flip_card.card, table_card.card})
	animate_card(table_card, PLAYER_COLLECTION_ANCHOR)
	animate_card(state.flip_card, PLAYER_COLLECTION_ANCHOR)
	append(&player.collection, state.flip_card, table_card)
	ordered_remove(&state.table, target_index)
	end_turn()
}

// play a card from your hand.
// optionally, match with a card on the table, adding both of them to your collection
hand_play :: proc(player: ^Player, hand_index: int) {
	hand_card := player.hand[hand_index]
	log.debug(state.phase, "play", hand_card.card)

	// add to table
	append(&state.table, hand_card)

	// remove from hand
	ordered_remove(&player.hand, hand_index)
	state.hand_index = 0

	// animate
	animate_card(hand_card, TABLE_ANCHOR)

	// trigger next phase of the turn
	start_flip(player)
}

hand_match :: proc(player: ^Player, hand_index, table_index: int) {
	hand_card := player.hand[hand_index]
	table_card := state.table[table_index]
	log.debug(state.phase, "match", [2]Card{hand_card.card, table_card.card})

	// add cards to collection
	append(&player.collection, hand_card)
	append(&player.collection, table_card)

	// remove from table
	ordered_remove(&player.hand, hand_index)
	ordered_remove(&state.table, table_index)
	state.hand_index = 0
	state.table_index = 0

	// animate
	animate_card(hand_card, PLAYER_COLLECTION_ANCHOR)
	animate_card(table_card, PLAYER_COLLECTION_ANCHOR)

	// trigger next phase of the turn
	start_flip(player)
}

// returns the indices of matchable cards from the given collection
get_matches :: proc(target: Card, source: []CardEntity) -> (matches: [dynamic]int) {
	for card, i in source {
		if card_is_same_month(card.card, target) {
			append(&matches, i)
		}
	}
	return matches
}

set_phase :: proc(phase: Phase) {state.phase = phase}
set_scene :: proc(scene: Scene) {state.scene = scene}
