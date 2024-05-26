extends Button
class_name SceneChangeButton

@export var scene_name :String

func _ready():
	if !pressed.is_connected(on_pressed):
		pressed.connect(on_pressed)
	if !(scene_name):
		scene_name = "res://Scenes/Levels/Scenes/"+get_tree().current_scene.name+".tscn"

func on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_name)
