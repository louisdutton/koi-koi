package main

import "color"

CARD_SIZE :: Vec2{60, 100}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: color.PINK
OUTLINE_OFFSET :: 0
OUTLINE_THICKNESS :: 4

// debug flags
SHOW_OPPONENTS_HAND :: false

// renders the given card
draw_card :: proc(card: CardEntity) {
	if (.Hidden in card.flags) {
		fill_rect(card.position, CARD_SIZE, color.BLACK)
		return
	}

	border := .Outline in card.flags ? OUTLINE_COLOUR : color.BLACK
	alpha: f32 = .Faded in card.flags ? 0.5 : 1

	fill_rect(card.position, CARD_SIZE, color.fade(border, alpha))
	fill_rect(
		card.position + CARD_BORDER_WIDTH,
		CARD_SIZE - CARD_BORDER_WIDTH * 2,
		color.fade(color.WHITE, alpha),
	)
	tex := get_card_texture(card.card)
	draw_texture(tex, card.position + CARD_BORDER_WIDTH, 0, 0.102, color.fade(color.WHITE, alpha))
}

// renders the deck
draw_deck :: proc() {
	fill_rect(
		Vec2{SCREEN_WIDTH * 0.75, SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
		CARD_SIZE,
		color.BLACK,
	)
}
