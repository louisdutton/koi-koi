package audio

import "vendor:raylib"

Music_Kind :: enum u8 {
	Demo,
}

@private
MUSIC_PATHS : [Music_Kind]cstring: {
 .Demo = "assets/audio/music/demo.mp3"
}

@private
music: [Music_Kind]raylib.Music

@private
music_load :: proc() {
  for path, key in MUSIC_PATHS {
    music[key] = raylib.LoadMusicStream(path)
  }
}

@private
music_unload :: proc() {
  for m in music {
    raylib.UnloadMusicStream(m)
  }
}

music_play :: proc() {raylib.PlayMusicStream(music[.Demo])}
music_stop :: proc() {raylib.StopMusicStream(music[.Demo])}
music_update :: proc() {raylib.UpdateMusicStream(music[.Demo])}
music_set_volume :: proc(volume: f32) {raylib.SetMusicVolume(music[.Demo], volume)}

