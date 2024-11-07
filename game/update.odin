package main

import "core:fmt"
import "core:time"
import r "vendor:raylib"

HAND_SIZE :: 8

selected := 0

update :: proc() {

	switch state {
	case .Pause:
		if r.IsKeyPressed(.P) {state = .Play}
	case .Play:
		if r.IsKeyPressed(.P) {state = .Pause}
		if r.IsKeyPressed(LEFT) {selected = max(selected - 1, 0)}
		if r.IsKeyPressed(RIGHT) {selected = min(selected + 1, HAND_SIZE - 1)}
	case .GameOver:
		if r.IsKeyPressed(.ENTER) {state = .Play}
	}
}
