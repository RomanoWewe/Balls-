extends AnimationPlayer
class_name CustomAnimator

@export var play_on_ready: StringName


func _ready():
	if play_on_ready:
		play(play_on_ready)
