extends Rail
class_name TurningRail

@export var start : Node3D
@export var finish : Node3D

func get_minecart_direction(minecart):
	var turning_progress = get_turning_progress(minecart)
	return start.global_basis.slerp(finish.global_basis,turning_progress)
	
func get_turning_progress(minecart):
	return Vector3(
		abs(minecart.global_position.x-start.global_position.x)/abs(finish.global_position.x-start.global_position.x) if (!is_equal_approx(finish.global_position.x,start.global_position.x)) else 0,
		abs(minecart.global_position.y-start.global_position.y)/abs(finish.global_position.y-start.global_position.y) if (!is_equal_approx(finish.global_position.y,start.global_position.y)) else 0,
		abs(minecart.global_position.z-start.global_position.z)/abs(finish.global_position.z-start.global_position.z) if (!is_equal_approx(finish.global_position.z,start.global_position.z)) else 0
	).length()/sqrt(2)
