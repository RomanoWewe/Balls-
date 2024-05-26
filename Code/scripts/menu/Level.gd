extends Node3D
class_name Level

@export var time_limit := 0.0

var levels_progress : Progress
var level_complete_scene = preload("res://Scenes/Menu/LevelCompleteScreen.tscn")
var level_fail_scene = preload("res://Scenes/Menu/LevelFailScreen.tscn")
var pause_ui = preload("res://Scenes/Menu/LevelUI.tscn")

var time_since_start := 0.0
var level_finished := false

func _ready():
	if ResourceLoader.exists("user://saves/progress.tres"):
		levels_progress = ResourceLoader.load("user://saves/progress.tres")
	else:
		levels_progress = Progress.new()
	add_child(pause_ui.instantiate())
	PhysicsServer3D.space_set_param(get_world_3d().space, PhysicsServer3D.SPACE_PARAM_CONTACT_MAX_ALLOWED_PENETRATION, 0.0)

func _process(delta):
	time_since_start+=delta

func complete_level():
	if (level_finished):
		return
	level_finished = true
	levels_progress.level_completion_data[int(str(name))] = true
	if time_since_start<time_limit:
		levels_progress.level_in_time_data[int(str(name))] =true
	ResourceSaver.save(levels_progress,"user://saves/progress.tres", ResourceSaver.FLAG_COMPRESS)
	var screen = level_complete_scene.instantiate()
	add_child(screen)
	var lvl_name = str(int(str(name))+1)+".tscn"
	if Array(DirAccess.open("res://Scenes/Levels/Scenes").get_files()).has(lvl_name):
		screen.get_node("CenterContainer/Panel/NextLevelButton").scene_name = \
		"res://Scenes/Levels/Scenes/"+lvl_name
	else:
		screen.get_node("CenterContainer/Panel/NextLevelButton").queue_free()

func fail_level():
	if (level_finished):
		return
	level_finished = true
	var screen = level_fail_scene.instantiate()
	add_child(screen)
	var lvl_name = name+".tscn"
	if Array(DirAccess.open("res://Scenes/Levels/Scenes").get_files()).has(lvl_name):
		screen.get_node("CenterContainer/Panel/NextLevelButton").scene_name = \
		"res://Scenes/Levels/Scenes/"+lvl_name
	else:
		screen.get_node("CenterContainer/Panel/NextLevelButton").queue_free()

