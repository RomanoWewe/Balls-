extends BossState
class_name BossInitialState

@export var altar:Node3D

func enter()->void:
	pass

func update(_delta:float)->void:
	pass

func exit():
	altar.queue_free()
	super.exit()

func on_rune_used()->void:
	%BodyAnimator.current_animation="activation"
	%RuneUseAnimator.current_animation="rune1"
	await get_tree().create_timer(1).timeout
	%BossIntro.play()
	await get_tree().create_timer(4).timeout
	exit()
	await get_tree().create_timer(2).timeout
	%Music.play()
