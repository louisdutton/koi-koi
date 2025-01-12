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
  Stalk,     JanScroll, JanA,      JanB,
	FebSeed,   FebScroll, FebA,      FebB,
  Curtain,   MarScroll, MarA,      MarB,
	AprSeed,   AprScroll, AprA,      AprB,
	MaySeed,   MayScroll, MayA,      MayB,
	Butterfly, JunScroll, JunA,      JunB,
	Boar,      JulScroll, JulA,      JulB,
	FullMoon,  AugSeed,   AugA,      AugB,
	SakeCup,   SepScroll, SepA,      SepB,
	Deer,      OctScroll, OctA,      OctB,
	RainMan,   NovSeed,   NovScroll, NovA,
	Phoenix,   DecA,      DecB,      DecC,   
}
//odinfmt: enable

CardSet :: distinct bit_set[Card]

CARD_KINDS :: [Card]CardKind {
	// January
	.Stalk     = .Light,
	.JanScroll = .Scroll,
	.JanA      = .Chaff,
	.JanB      = .Chaff,

	// February
	.FebSeed   = .Seed,
	.FebScroll = .Scroll,
	.FebA      = .Chaff,
	.FebB      = .Chaff,

	// March
	.Curtain   = .Light,
	.MarScroll = .Scroll,
	.MarA      = .Chaff,
	.MarB      = .Chaff,

	// April
	.AprSeed   = .Seed,
	.AprScroll = .Scroll,
	.AprA      = .Chaff,
	.AprB      = .Chaff,

	// May
	.MaySeed   = .Seed,
	.MayScroll = .Scroll,
	.MayA      = .Chaff,
	.MayB      = .Chaff,

	// June
	.Butterfly = .Seed,
	.JunScroll = .Scroll,
	.JunA      = .Chaff,
	.JunB      = .Chaff,

	// July
	.Boar      = .Seed,
	.JulScroll = .Scroll,
	.JulA      = .Chaff,
	.JulB      = .Chaff,

	// August
	.FullMoon  = .Light,
	.AugSeed   = .Seed,
	.AugA      = .Chaff,
	.AugB      = .Chaff,

	// September
	.SakeCup   = .Seed,
	.SepScroll = .Scroll,
	.SepA      = .Chaff,
	.SepB      = .Chaff,

	// October
	.Deer      = .Seed,
	.OctScroll = .Scroll,
	.OctA      = .Chaff,
	.OctB      = .Chaff,

	// November
	.RainMan   = .Light,
	.NovSeed   = .Seed,
	.NovScroll = .Scroll,
	.NovA      = .Chaff,

	// December
	.Phoenix   = .Light,
	.DecA      = .Chaff,
	.DecB      = .Chaff,
	.DecC      = .Chaff,
}
