package main

CardKind :: enum u8 {
	Chaff,
	Scroll,
	Seed,
	Light,
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

//odinfmt: disable
Card :: enum u8 {
  Jan0, Jan1, Jan2, Jan3,
	Feb0, Feb1, Feb2, Feb3,
	Mar0, Mar1, Mar2, Curtain,
	Apr0, Apr1, Apr2, Apr3,
	May0, May1, May2, May3,
	Jun0, Jun1, Jun2, Butterfly,
	Jul0, Jul1, Jul2, Boar,
	Aug0, Aug1, Aug2, FullMoon,
	Sep0, Sep1, Sep2, SakeCup,
	Oct0, Oct1, Oct2, Deer,
	Nov0, Nov1, Nov2, RainMan,
	Dec0, Dec1, Dec2, Dec3,   
}
//odinfmt: enable

CardSet :: distinct bit_set[Card]

CARD_KINDS :: [Card]CardKind {
	// January
	.Jan0      = .Light,
	.Jan1      = .Scroll,
	.Jan2      = .Chaff,
	.Jan3      = .Chaff,

	// February
	.Feb0      = .Seed,
	.Feb1      = .Scroll,
	.Feb2      = .Chaff,
	.Feb3      = .Chaff,

	// March
	.Mar0      = .Light,
	.Mar1      = .Scroll,
	.Mar2      = .Chaff,
	.Curtain   = .Chaff,

	// April
	.Apr0      = .Seed,
	.Apr1      = .Scroll,
	.Apr2      = .Chaff,
	.Apr3      = .Chaff,

	// May
	.May0      = .Seed,
	.May1      = .Scroll,
	.May2      = .Chaff,
	.May3      = .Chaff,

	// June
	.Jun0      = .Seed,
	.Jun1      = .Scroll,
	.Jun2      = .Chaff,
	.Butterfly = .Chaff,

	// July
	.Jul0      = .Seed,
	.Jul1      = .Scroll,
	.Jul2      = .Chaff,
	.Boar      = .Chaff,

	// August
	.Aug0      = .Light,
	.Aug1      = .Seed,
	.Aug2      = .Chaff,
	.FullMoon  = .Chaff,

	// September
	.Sep0      = .Seed,
	.Sep1      = .Scroll,
	.Sep2      = .Chaff,
	.SakeCup   = .Chaff,

	// October
	.Oct0      = .Seed,
	.Oct1      = .Scroll,
	.Oct2      = .Chaff,
	.Deer      = .Chaff,

	// November
	.Nov0      = .Light,
	.Nov1      = .Seed,
	.Nov2      = .Scroll,
	.RainMan   = .Chaff,

	// December
	.Dec0      = .Light,
	.Dec1      = .Chaff,
	.Dec2      = .Chaff,
	.Dec3      = .Chaff,
}
