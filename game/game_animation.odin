package main

import "core:math"

Animation :: struct {
	card:  Card,
	from:  Vec2,
	to:    Vec2,
	start: f64,
	end:   f64,
}

// TODO delete once we have multiple scene
animations: [dynamic]Animation

get_animation :: proc(card: Card) -> (Animation, int, bool) {
	for anim, i in animations {
		if anim.card == card {
			return anim, i, true
		}
	}
	return {}, 0, false
}

ease_out_expo :: proc(x: $T) -> T {
	return x == 1 ? 1 : 1 - math.pow(2, -10 * x)
}

lerp_vec2 :: proc(a, b: Vec2, t: f32) -> Vec2 {
	return Vec2{math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t)}
}

animate_card :: proc(card: CardEntity, to: Vec2) {
	duration :: 0.5
	append(
		&animations,
		Animation {
			card = card.card,
			from = card.position,
			to = to,
			start = state.elapsed,
			end = state.elapsed + duration,
		},
	)
}
