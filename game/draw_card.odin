package main

import "core:fmt"
import "core:math/rand"
import "core:slice"
import "core:strings"
import r "vendor:raylib"

CARD_SIZE :: Vec2{60, 100}
CARD_BORDER_WIDTH :: 4

SELECTED_VERTICAL_OFFSET :: 10
TABLE_SPACING :: int(CARD_SIZE.x) + 2

OUTLINE_COLOUR :: r.PINK
OUTLINE_OFFSET :: 0
OUTLINE_THICKNESS :: 4

// debug flags
SHOW_OPPONENTS_HAND :: false


draw_card :: proc(card: CardEntity) {
	if (.Hidden in card.flags) {
		r.DrawRectangleV(card.position, CARD_SIZE, r.BLACK)
		return
	}

	border := .Outline in card.flags ? OUTLINE_COLOUR : r.BLACK
	alpha: f32 = .Faded in card.flags ? 0.5 : 1

	r.DrawRectangleV(card.position, CARD_SIZE, r.Fade(border, alpha))
	r.DrawRectangleV(
		card.position + CARD_BORDER_WIDTH,
		CARD_SIZE - CARD_BORDER_WIDTH * 2,
		r.Fade(r.WHITE, alpha),
	)
	tex := get_card_texture(card.card)
	r.DrawTextureEx(tex, card.position + CARD_BORDER_WIDTH, 0, 0.102, r.Fade(r.WHITE, alpha))
}

draw_deck :: proc() {
	r.DrawRectangleV(
		Vec2{SCREEN_WIDTH * 0.75, SCREEN_HEIGHT / 2 - CARD_SIZE.y / 2},
		CARD_SIZE,
		r.BLACK,
	)
}
