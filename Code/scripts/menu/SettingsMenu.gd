extends Control
class_name SettingsMenu

@export var DEFAULT_HEIGHT = 720

var settings : Settings
@export var interface_node := Control

func _ready():
	if settings:
		return
	if   FileAccess.file_exists("user://settings.tres"):
		settings = load("user://settings.tres")
	else:
		settings = Settings.new()
	$Options/Resolution/OptionButton.select(settings.resolution)
	$Options/Fullscreen/CenterContainer/CheckBox.button_pressed = settings.fullscreen
	$Options/MusicVolume2/CenterContainer/CheckBox.button_pressed = settings.is_music_mute
	$Options/SoundVolume/CenterContainer/CheckBox.button_pressed = settings.is_sound_mute
	apply_settings()

func _on_resolution_set(index):
	settings.resolution = index
	apply_settings()

func _on_fullscreen_set(toggled_on):
	settings.fullscreen = toggled_on
	apply_settings()

func _on_apply_pressed():
	ResourceSaver.save(settings,"user://settings.tres")
	apply_settings()

func apply_settings():
	var window = get_window()
	if settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var center = window.position + window.size/2
		window.size = settings.resolutions[settings.resolution]
		window.position = center - window.size/2
	interface_node.scale = Vector2(float(window.size.y)/DEFAULT_HEIGHT,
		float(window.size.y)/DEFAULT_HEIGHT)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),settings.is_music_mute)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Sound"),settings.is_sound_mute)

func _on_sound_toggled(toggled_on):
	settings.is_sound_mute = toggled_on
	apply_settings()

func _on_music_toggled(toggled_on):
	settings.is_music_mute = toggled_on
	apply_settings()

