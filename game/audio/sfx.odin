package audio

import "vendor:raylib"

// available sounds
SFX_Kind :: enum {
	Click,
}

// project-relative paths for sfx files
@private
SFX_PATHS: [SFX_Kind]cstring : {.Click =  "assets/audio/sfx/click.wav"}

@private
sfx: [SFX_Kind]raylib.Sound

// loads all sfx
@private
sfx_load :: proc() {
	for path, key in SFX_PATHS {
		sfx[key] = raylib.LoadSound(path)
	}
}

// unloads all sfx
@private
sfx_unload :: proc() {
	for sound in sfx {
		raylib.UnloadSound(sound)
	}
}

// plays the target sfx
sfx_play :: proc(kind: SFX_Kind) {raylib.PlaySound(sfx[kind])}
