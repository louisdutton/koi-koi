package main


Month :: enum u8 {
	January,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	November,
	December,
}

card_get :: proc(month: Month, index: u8) -> Card {
	return u8(month) * MONTH_SIZE + index
}

card_is_same_month :: proc(a: Card, b: Card) -> bool {
	return a / MONTH_SIZE == b / MONTH_SIZE
}
