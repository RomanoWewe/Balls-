extends Control
class_name StaticLevelUI

static var singleton : StaticLevelUI

var runes_activated:=false
@export var rune_empty :Texture2D
@export var rune_icons :Array[TextureRect]

func _ready():
	singleton=self
	for rune in rune_icons:
		rune.texture=rune_empty
	var level = get_tree().root.get_child(0)
	$"Level number".text = "[center]Level "+ level.name
	level.skins.achievement_animator = get_parent().get_node("AchievemtPopupAnimator")

func add_rune_icon(rune_icon:Texture2D):
	if !runes_activated:
		runes_activated=true
		$RuneAnimator.current_animation="Active"
	for icon in rune_icons:
		if icon.texture==rune_empty:
			icon.texture=rune_icon
			return
	push_error("runes full")
	
func remove_rune_icon(rune_icon:Texture2D):
	if !runes_activated:
		push_error("runes not active")
	for icon in rune_icons:
		if icon.texture==rune_icon:
			icon.texture=rune_empty
			check_runes_empty()
			return
	push_error("no runes to remove")

func check_runes_empty():
	for icon in rune_icons:
		if icon.texture != rune_empty:
			return
	await get_tree().create_timer(.7).timeout
	$RuneAnimator.current_animation="Unactive"
