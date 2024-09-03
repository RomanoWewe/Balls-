extends Activatable
class_name RailBarrier

enum rail_barrier_state {OPEN, CLOSED, HALF_CLOSED}

var current_state= rail_barrier_state.CLOSED
var flip_flop = 1
var rail : Node3D

func _ready():
	rail= get_parent().get_node_or_null(str(int(name.split(",")[0])+5)+","+",".join(name.split(",").slice(1)))
	if rail!=null:
		rail.call_deferred("reparent",$"КрутящийЕлемент(вал)/top")

func add_steps(steps : int):
	var object = $AreaTracker.get_first_object()
	match current_state:
		rail_barrier_state.OPEN:
			if object != null:
				current_state=rail_barrier_state.HALF_CLOSED
				$AnimationPlayer.current_animation="half_close"
				object.freeze=true
				object.linear_velocity=Vector3()
				$AudioStreamPlayer.play()
			else:
				current_state=rail_barrier_state.CLOSED
				$AnimationPlayer.current_animation="close"
		rail_barrier_state.CLOSED:
			current_state=rail_barrier_state.OPEN
			$AnimationPlayer.current_animation="open"
		rail_barrier_state.HALF_CLOSED:
			current_state=rail_barrier_state.OPEN
			$AnimationPlayer.current_animation="half_open"
			object.freeze=false
