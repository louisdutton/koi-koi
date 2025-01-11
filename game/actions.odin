package main

import "core:log"

start_flip :: proc(player: ^Player) {
	state.flip_card = pop(&state.deck)
	state.matches = get_matches(state.flip_card, state.table[:])
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
		if collection_has_yaku(state.player.collection) {
			win()
		}
		set_phase(.OpponentHand)
	case .OpponentHand:
		if collection_has_yaku(state.opponent.collection) {
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
	log.debug("flip-play", state.phase, state.flip_card)
	append(&state.table, state.flip_card)
	end_turn()
}

// match the flipped card with a card on the table
// ends the current turn on completion
flip_match :: proc(player: ^Player, target_index: int) {
	log.debug("flip-match", state.phase, state.flip_card, state.table[target_index])
	append(&player.collection, state.flip_card, state.table[target_index])
	ordered_remove(&state.table, target_index)
	end_turn()
}

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

// returns the indices of matchable cards from the given collection
get_matches :: proc(target: Card, source: []Card) -> (matches: [dynamic]int) {
	for card, i in source {
		if card_is_same_month(card, target) {
			append(&matches, i)
		}
	}
	return matches
}

set_phase :: proc(phase: Phase) {state.phase = phase}
set_scene :: proc(scene: Scene) {state.scene = scene}
