extends Control
class_name LevelSelectionController

@export var level_icon_prefab : PackedScene
@onready var grid_node = get_node("GridContainer") 
var selected : LevelSelectButton
var SCENES_PATH = "res://Scenes/Levels/Scenes/"
var scenes_directory = DirAccess.open(SCENES_PATH)
var progress : Progress

static var singleton :LevelSelectionController

func _ready():
	singleton = self
	if !DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")
	if ResourceLoader.exists("user://saves/progress.tres"):
		progress = ResourceLoader.load("user://saves/progress.tres")
	else:
		progress = Progress.new()
	open_page()

func open_page():
	
	var levels = Array(DirAccess.open(SCENES_PATH).get_files())
	levels.sort_custom(custom_string_sort)
	var level_completion_data = progress.level_completion_data
	var level_icons = grid_node.get_children()
	for level in level_icons:
		if levels.find(level.name+".tscn") == -1:
			level.queue_free()
		else:
			level.disabled = !level_completion_data[int(str(level.name))-1]

func custom_string_sort(a, b):
	return int(a)<int(b)

func custom_node_sort(a, b):
	return int(str(a.name))<int(str(b.name))

func select_level(button : LevelSelectButton):
	if selected:
		selected.button_pressed=false
	selected = button
	selected.button_pressed = true

func load_selected_level():
	if !selected:
		return
	get_tree().change_scene_to_file(SCENES_PATH+selected.name+".tscn")
