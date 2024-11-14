package main

import "core:math/rand"
import r "vendor:raylib"

// card counts
HAND_SIZE :: 8
TABLE_MAX :: HAND_SIZE * 2
MONTH_SIZE :: 4
MONTH_COUNT :: 12
DECK_SIZE :: MONTH_SIZE * MONTH_COUNT

Card :: u8

Player :: struct {
	hand:       [dynamic]Card,
	collection: [dynamic]Card,
}

deck: [dynamic]Card
table: [dynamic]Card

player: Player
opponent: Player

init :: proc() {
	// generate deck
	deck = make([dynamic]Card, DECK_SIZE, DECK_SIZE)
	for i in 0 ..< DECK_SIZE {deck[i] = u8(i)}
	rand.shuffle(deck[:])

	// deal table
	table = make([dynamic]Card, 0, TABLE_MAX)
	for i in 0 ..< HAND_SIZE {append(&table, pop(&deck))}

	// deal player
	player = Player {
		hand       = make([dynamic]Card, 0, HAND_SIZE),
		collection = make([dynamic]Card, 0, DECK_SIZE),
	}
	for i in 0 ..< HAND_SIZE {append(&player.hand, pop(&deck))}

	// deal opponent
	opponent = Player {
		hand       = make([dynamic]Card, 0, HAND_SIZE),
		collection = make([dynamic]Card, 0, DECK_SIZE),
	}
	for i in 0 ..< HAND_SIZE {append(&opponent.hand, pop(&deck))}
}
