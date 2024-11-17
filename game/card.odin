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

get_card :: proc(month: Month, index: u8) -> Card {
	return u8(month) * MONTH_SIZE + index
}
