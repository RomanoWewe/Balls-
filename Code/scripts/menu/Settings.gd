extends Resource
class_name Settings

var resolutions = [
	Vector2(640, 360),
	Vector2(854, 480),
	Vector2(960, 540),
	Vector2(1024, 576),
	Vector2(1280, 720),
	Vector2(1366, 768),
	Vector2(1600, 900),
	Vector2(1920, 1080)
	]

@export var resolution = 4
@export var fullscreen = false

@export var is_sound_mute = false
@export var is_music_mute = false
