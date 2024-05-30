extends RigidBody3D
class_name Minecart

@export var visual_rotation_speed:=1.0
@export var max_speed := 10
var current_rail : Rail
var is_reversed : bool

func _physics_process(delta):
	if current_rail == null:
		return
	# Calculate the direction of the rail tangent
	var rail_tangent = current_rail.global_transform.basis.x.normalized()  # Assuming the rail tangent is along the Y-axis of its local space

	# Project the minecart's velocity onto the rail tangent
	var vel_directional = linear_velocity.project(rail_tangent)
	linear_velocity = vel_directional.normalized() * clamp(linear_velocity.length(), 0, max_speed)
	
	is_reversed = ((linear_velocity.normalized()==global_basis.x) if linear_velocity.length()>0 else  true)
	
	global_basis = current_rail.get_minecart_direction($Area3D)
	if is_reversed :
		global_basis = global_basis * Basis.FLIP_X

	# Calculate the position along the rail
	var local_minecart_position = current_rail.to_local(position)
	var new_local_minecart_position = local_minecart_position.project(Vector3(1,0,0))
	position = current_rail.to_global(new_local_minecart_position)

func try_set_rail(rail:Rail):
	if current_rail == null or bool(rail.catch_mask & current_rail.release_mask):
		current_rail=rail
