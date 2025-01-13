package audio
import "core:fmt"

import "vendor:raylib"

load :: proc() {
	raylib.InitAudioDevice()
  music_load()
	sfx_load()
}

unload :: proc() {
	music_unload()
	sfx_unload()
	raylib.CloseAudioDevice()
}
