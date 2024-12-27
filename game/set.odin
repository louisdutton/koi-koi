package main

import "core:log"

Yaku :: enum u8 {
	BoarDearButterfly,
	CherryBlossomViewing,
	MoonViewing,
}

YAKU_SETS :: [Yaku]CardSet {
	.BoarDearButterfly    = {.Boar, .Deer, .Butterfly},
	.CherryBlossomViewing = {.SakeCup, .Curtain},
	.MoonViewing          = {.SakeCup, .FullMoon},
}

YAKU_POINTS :: [Yaku]u8 {
	.BoarDearButterfly    = 5,
	.CherryBlossomViewing = 5,
	.MoonViewing          = 5,
}

collection_has_set :: proc(collection: [dynamic]Card) -> bool {
	groups: map[CardKind]int
	defer delete(groups)
	for card in collection {
		kind := card_get_kind(card)
		groups[kind] += 1
	}

	// unique sets
	collection_set := CardSet{}
	for card in collection {
		collection_set += {card}
	}
	for yaku in YAKU_SETS {
		if collection_set >= yaku {
			return true
		}
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
