extends Control
class_name SettingsMenu

@export var DEFAULT_HEIGHT = 720

static var settings : Settings
@export var interface_node := Control
@export var fps_counter :RichTextLabel
@export var resolution_menu : OptionButton
@export var fullscreen_button : Button
@export var sound_mute_button : Button
@export var music_mute_button : Button

func _ready():
	if !InputMap.has_action("F2"):
		InputMap.add_action("F2")
		var ev = InputEventKey.new()
		ev.keycode = KEY_F2
		InputMap.action_add_event("F2", ev)
	if settings == null:
		if   FileAccess.file_exists("user://settings.tres"):
			settings = load("user://settings.tres")
		else:
			settings = Settings.new()
	resolution_menu.select(settings.resolution)
	fullscreen_button.button_pressed = settings.fullscreen
	music_mute_button.button_pressed = settings.is_music_mute
	sound_mute_button.button_pressed = settings.is_sound_mute
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

func _process(_delta):
	if Input.is_action_just_pressed("F2"):
		settings.show_fps= !settings.show_fps
	if fps_counter!=null:
		if settings.show_fps:
			fps_counter.text = "%d" % Engine.get_frames_per_second()
		else:
			fps_counter.text = ""
