package main

card_from_suit :: proc(suit: Suit, index: u8) -> Card {
	return Card(u8(suit) * MONTH_SIZE + index)
}

card_is_same_month :: proc(a: Card, b: Card) -> bool {
	return card_get_suit(a) == card_get_suit(b)
}

card_get_suit :: proc(card: Card) -> Suit {
	return Suit(u8(card) / MONTH_SIZE)
}

card_get_kind :: proc(card: Card) -> CardKind {
	kinds := CARD_KINDS // FIXME: shouldn't need to do this
	return kinds[card]
}
