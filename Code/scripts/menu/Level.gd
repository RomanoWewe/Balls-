extends Node3D
class_name Level

var wind_ambient :=load("res://Scenes/Objects/_Abstract/ambientWind.tscn")
var desert_ambient :=load("res://Scenes/Objects/_Abstract/ambientDesert.tscn")
var mine_ambient :=load("res://Scenes/Objects/_Abstract/ambientMine.tscn")

var skins : SkinsMenu
var level_complete_scene = preload("res://Scenes/Menu/LevelCompleteScreen.tscn")
var level_fail_scene = preload("res://Scenes/Menu/LevelFailScreen.tscn")
var pause_ui = preload("res://Scenes/Menu/LevelUI.tscn")

var level_finished := false
var runes_collected : Array[Texture2D] =[]

func _ready():
	skins=SkinsMenu.new()
	add_child(skins)
	pause_ui = pause_ui.instantiate()
	add_child(pause_ui)
	PhysicsServer3D.space_set_param(get_world_3d().space, PhysicsServer3D.SPACE_PARAM_CONTACT_MAX_ALLOWED_PENETRATION, 0.0)
	if int(str(name)) <21:
		add_child(wind_ambient.instantiate())
	elif int(str(name)) >40 and int(str(name))<61:
		add_child(desert_ambient.instantiate())
	elif int(str(name)) >60 and int(str(name))<81:
		add_child(mine_ambient.instantiate())

func complete_level():
	if (level_finished):
		return
	level_finished = true
	if skins.stats.levels_completed<int(str(name)):
		skins.stats.levels_completed+=1
	skins.refresh()
	var screen = level_complete_scene.instantiate()
	pause_ui.add_child(screen)
	var lvl_name = str(int(str(name))+1)+".tscn"
	if Array(DirAccess.open("res://Scenes/Levels/Scenes").get_files()).has(lvl_name):
		screen.get_node("NextLevelButton").scene_name = \
		"res://Scenes/Levels/Scenes/"+lvl_name
	else:
		screen.get_node("NextLevelButton").queue_free()

func fail_level():
	if (level_finished):
		return
	
	level_finished = true
	var screen = level_fail_scene.instantiate()
	pause_ui.add_child(screen)
	var lvl_name = name+".tscn"
	if Array(DirAccess.open("res://Scenes/Levels/Scenes").get_files()).has(lvl_name):
		screen.get_node("NextLevelButton").scene_name = \
		"res://Scenes/Levels/Scenes/"+lvl_name
	else:
		screen.get_node("NextLevelButton").scene_name = "res://Scenes/MainMenu.tscn"
		screen.get_node("NextLevelButton").text = "Return to menu"
	skins.refresh()

func rune_collected(rune:Texture2D):
	runes_collected.append(rune)
	StaticLevelUI.singleton.add_rune_icon(rune)

func rune_used(rune:Texture2D):
	for i in runes_collected:
		if i==rune:
			runes_collected.erase(i)
			StaticLevelUI.singleton.remove_rune_icon(rune)
			return
