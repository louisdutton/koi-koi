package main

import "core:fmt"
import "core:strings"
import r "vendor:raylib"

ASSET_PATH :: "assets"

@(private = "file")
card_textures: [DECK_SIZE]Texture

@(private = "file")
load_card_tex :: proc(m, c: int) -> Texture {
	path := fmt.tprintf("%s/png/%v-%v.png", ASSET_PATH, m, c)
	return load_texture(path)
}

@(private = "file")
load_texture :: proc(path: string) -> Texture {
	c_path := strings.clone_to_cstring(path)
	defer delete(c_path)
	return r.LoadTexture(c_path)
}

load_images :: proc() {
	for m in 0 ..< MONTH_COUNT {
		for c in 0 ..< MONTH_SIZE {
			index := (m * MONTH_SIZE) + c
			card_textures[index] = load_card_tex(m, c)
		}
	}
}

unload_images :: proc() {
	for tex in card_textures {
		r.UnloadTexture(tex)
	}
}

get_card_texture :: proc(card: Card) -> Texture {
	return card_textures[card]
}
