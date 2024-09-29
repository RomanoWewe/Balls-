extends Resource
class_name Stats

@export var journey_started := 1

@export var deaths_total := 0
@export var deaths_by_cannon := 0
@export var deaths_by_fall:= 0
@export var deaths_by_cultist:= 0
@export var deaths_by_doppelghanger:= 0

@export var levels_completed:= 0
@export var unlocked_skins_count:= 0
@export var skins_changed:= 0
@export var teleports_used:= 0
@export var secrets_unlocked:= 0

@export var unlocked_skins : Array[bool] = []

func _init():
	for skin in load("res://skindata.tres").names:
		unlocked_skins.append(false)
