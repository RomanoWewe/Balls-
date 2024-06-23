extends Button
class_name SceneChangeButton

@export var scene_name :String
@onready var texture_clicked : NinePatchRect = get_node("NinePatchRect")

var clicked_color = Color(1,1,1,1)
var blank_color = Color(0,0,0,0)

func _ready():
	texture_clicked.self_modulate = blank_color
	if !pressed.is_connected(on_pressed):
		pressed.connect(on_pressed)
	if !(scene_name):
		scene_name = "res://Scenes/Levels/Scenes/"+get_tree().current_scene.name+".tscn"

func on_pressed():
	texture_clicked.self_modulate = clicked_color if button_pressed else blank_color
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_name)
