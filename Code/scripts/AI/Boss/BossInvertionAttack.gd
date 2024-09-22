extends BossState
class_name BossInvertionState

@export var inverse_z:=true
@export var inverse_x:=true

func enter()->void:
	await get_tree().create_timer(1).timeout
	%Ball.inverse_z=inverse_z
	%Ball.inverse_x=inverse_x
	await get_tree().create_timer(1).timeout
	exit()
