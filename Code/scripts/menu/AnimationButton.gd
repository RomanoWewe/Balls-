extends Button
class_name AnimationButton

@export var animator : AnimationPlayer
@export var animation_to_play :String

func _ready():
	if !pressed.is_connected(on_pressed):
		pressed.connect(on_pressed)

func on_pressed():
	animator.play(animation_to_play)
