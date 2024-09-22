extends BossState
class_name BossInitialState

@export var rune_use_animation_name : String
@export var rune_use_animation_duration : float

func enter()->void:
	pass

func update(_delta:float)->void:
	pass

func on_rune_used()->void:
	if rune_use_animation_name!="":
		%RuneUseAnimator.current_animation=rune_use_animation_name
		await get_tree().create_timer(rune_use_animation_duration).timeout
	else:
		push_warning("No animation set for rune use on state: "+name)
	exit()
