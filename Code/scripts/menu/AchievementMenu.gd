extends Control
class_name AchievementMenu

var COMPLETED_COLOR := Color(1,1,1,1)
var UNCOMPLETED_COLOR := Color(0,0,0,0.75)

var stats : Dictionary

var background_color_uncomplete = Color("#606060")
var background_color_complete = Color("#D3D3D3")
@onready var achievement_icons_node := get_node("AchievementIcons")


func _ready():
	stats = load("res://stats.tres").stats
	for icon in achievement_icons_node.get_children():
		var result = stats.get(icon.stat_to_track)
		if result ==null:
			return
		elif result<icon.value_required:
			icon.self_modulate = UNCOMPLETED_COLOR
		else:
			icon.self_modulate = COMPLETED_COLOR
