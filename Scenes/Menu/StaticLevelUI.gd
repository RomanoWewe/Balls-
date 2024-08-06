extends Control
class_name StaticLevelUI

func _ready():
	var level = get_tree().root.get_child(0)
	$"Level number".text = "[center]Level "+ level.name
	level.skins.achievement_animator = get_parent().get_node("AchievemtPopupAnimator")
