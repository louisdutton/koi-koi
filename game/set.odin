package main

import "core:log"

collection_has_set :: proc(collection: [dynamic]Card) -> bool {
	groups: map[CardKind]int
	defer delete(groups)
	for card in collection {
		kind := card_get_kind(card)
		groups[kind] += 1
	}

	log.debug(groups)

	// 5 scrolls
	if groups[.Scroll] >= 5 {
		return true
	}

	// 5 seeds
	if groups[.Seed] >= 5 {
		return true
	}

	// lights
	if groups[.Light] >= 3 {
		return true
	}

	// chaff
	if groups[.Chaff] >= 10 {
		return true
	}

	return false
}
