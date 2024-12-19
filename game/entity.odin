package main

EntityFlag :: enum u8 {
	Selected,
}

EntityFlags :: bit_set[EntityFlag]

Entity :: struct {
	handle:   u8,
	position: Vec2,
	card:     Card,
	flags:    EntityFlags,
}
