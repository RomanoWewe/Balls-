extends Activatable
class_name RailRotator

@export var forward_animation : String
@export var backward_animation : String
var flip_flop = 1
var rail : Node3D
func _ready():
	rail= get_parent().get_node_or_null(str(int(name.split(",")[0])+5)+","+",".join(name.split(",").slice(1)))
	if rail!=null:
		rail.call_deferred("reparent",$CollisionShape3D)

func add_steps(steps : int):
	if (flip_flop==1):
		$AnimationPlayer.current_animation = forward_animation
	else:
		$AnimationPlayer.current_animation = backward_animation
	flip_flop = - flip_flop
