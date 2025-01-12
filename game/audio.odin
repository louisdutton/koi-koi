package main

import "core:fmt"
import "vendor:raylib"

@(private = "file")
MUSIC_PATH :: ASSET_PATH + "/audio/music"
DEMO_MUSIC_PATH :: MUSIC_PATH + "/demo.mp3"

@(private = "file")
music: raylib.Music

load_audio :: proc() {
	raylib.InitAudioDevice()
	music := raylib.LoadMusicStream(MUSIC_PATH + "/demo.mp3")
}
unload_audio :: proc() {
	raylib.UnloadMusicStream(music)
	raylib.CloseAudioDevice()
}
music_play :: proc() {raylib.PlayMusicStream(music)}
music_stop :: proc() {raylib.StopMusicStream(music)}
music_update :: proc() {raylib.UpdateMusicStream(music)}
music_set_volume :: proc(volume: f32) {raylib.SetMusicVolume(music, volume)}
