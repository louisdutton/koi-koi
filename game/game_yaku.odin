package main

import "core:log"

Yaku :: enum u8 {
	BoarDearButterfly,
	CherryBlossomViewing,
	MoonViewing,
	WrittenScrolls,
	BlueScrolls,
}

YAKU_SETS :: [Yaku]CardSet {
	.BoarDearButterfly    = {.Boar, .Deer, .Butterfly},
	.CherryBlossomViewing = {.SakeCup, .Curtain},
	.MoonViewing          = {.SakeCup, .FullMoon},
	.WrittenScrolls       = {.JanScroll, .FebScroll, .MarScroll},
	.BlueScrolls          = {.JunScroll, .SepScroll, .OctScroll},
}

YAKU_POINTS :: [Yaku]u8 {
	.BoarDearButterfly    = 5,
	.CherryBlossomViewing = 5,
	.MoonViewing          = 5,
	.WrittenScrolls       = 5,
	.BlueScrolls          = 5,
}

collection_has_yaku :: proc(collection: []CardEntity) -> bool {
	groups: map[CardKind]int
	defer delete(groups)
	for card in collection {
		kind := card_get_kind(card.card)
		groups[kind] += 1
	}

	// unique sets
	collection_set := CardSet{}
	for card in collection {
		collection_set += {card.card}
	}
	for yaku in YAKU_SETS {
		if collection_set >= yaku {
			return true
		}
	}

	// 5 scrolls
	if groups[.Scroll] >= 5 {
		return true
	}

	// 5 seeds
	if groups[.Seed] >= 5 {
		return true
	}

	// lights
	switch {
	case groups[.Light] == 3 && .RainMan not_in collection_set:
		return true // Sanko (5)
	case groups[.Light] == 4:
		if .RainMan in collection_set {
			return true // Ame Shiko (7)
		} else {
			return true // Shiko (8)
		}
	case groups[.Light] == 5:
		return true // Goko (10)
	}

	// chaff
	if groups[.Chaff] >= 10 {
		return true
	}

	return false
}
