package main

Card :: u8

CardKind :: enum u8 {
	Chaff,
	Scroll,
	Seed,
	Light,
}

Unique :: enum Card {
	SakeCup   = u8(Suit.September) * MONTH_SIZE,
	Curtain   = u8(Suit.March) * MONTH_SIZE,
	FullMoon  = u8(Suit.August) * MONTH_SIZE,
	Boar      = u8(Suit.July) * MONTH_SIZE,
	Deer      = u8(Suit.October) * MONTH_SIZE,
	Butterfly = u8(Suit.June) * MONTH_SIZE,
	RainMan   = u8(Suit.November) * MONTH_SIZE,
}

Suit :: enum u8 {
	January, // pine
	February, // plum blossom
	March, // cherry blossom
	April, // wisteria
	May, // iris
	June, // peony
	July, // bush clover
	August, // susuki grass
	September, // chrysanthemum
	October, // maple
	November, // willow
	December, // paulownia
}

CARD_KINDS :: [DECK_SIZE]CardKind {
	// January
	.Light,
	.Scroll,
	.Chaff,
	.Chaff,

	// February
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// March
	.Light,
	.Scroll,
	.Chaff,
	.Chaff,

	// April
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// May
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// June
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// July
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// August
	.Light,
	.Seed,
	.Chaff,
	.Chaff,

	// September
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// October
	.Seed,
	.Scroll,
	.Chaff,
	.Chaff,

	// November
	.Light,
	.Seed,
	.Scroll,
	.Chaff,

	// December
	.Light,
	.Chaff,
	.Chaff,
	.Chaff,
}
