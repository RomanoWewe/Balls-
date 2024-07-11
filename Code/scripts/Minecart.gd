extends RigidBody3D
class_name Minecart

@export var visual_rotation_speed:=1.0
@export var max_speed := 10
@export var fill_level := 0
@export var gold_fill_meshes :Array[ArrayMesh] = []
var current_rail : Rail
var is_reversed : bool
var prev_basis_x : Vector3
var prev_position :Vector3

func _physics_process(delta):
	if current_rail == null:
		return
	var rail_tangent = current_rail.global_transform.basis.x.normalized()
	
	
	# Calculate the position along the rail
	var local_minecart_position = current_rail.to_local(position)
	var new_local_minecart_position = local_minecart_position.project(Vector3(1,0,0))
	position = current_rail.to_global(new_local_minecart_position)
	
	
	# Project the minecart's velocity onto the rail tangent
	var vel_directional = linear_velocity.project(rail_tangent)
	print(vel_directional.normalized())
	linear_velocity = vel_directional.normalized() * clamp(linear_velocity.length(), 0, max_speed)
	print(linear_velocity.length())
	
	print("difference: ",(position-prev_position).length()/delta-linear_velocity.length())
	prev_position=position
	
	
	
	global_basis = current_rail.get_minecart_direction($Area3D)
	is_reversed = (global_basis.x.angle_to(prev_basis_x) > PI/2 )
	if is_reversed :
		global_basis*= Basis(Vector3(-1,0,0),Vector3(0,1,0),Vector3(0,0,-1))
	prev_basis_x = global_basis.x

func try_set_rail(rail:Rail):
	if current_rail == null or bool(rail.catch_mask & current_rail.release_mask):
		current_rail=rail

func try_unset_rail(rail:Rail):
	if current_rail == rail:
		current_rail=null

func _on_area_3d_2_body_entered(body):
	if body.is_in_group("GoldBar"):
		body.queue_free()
		fill_level +=1
		fill_level = clamp(fill_level,0,3)
		$FillMesh.mesh=gold_fill_meshes[fill_level-1]
