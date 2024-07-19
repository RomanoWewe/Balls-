extends RigidBody3D
class_name Minecart

@export var max_speed := 10
@export var fill_level := 0
@export var gold_fill_meshes :Array[ArrayMesh] = []
@export var speed_damp :=0.998
var is_in_contact_with_ball := false
var previous_frame_horizontal_velocity := 0.0

func _physics_process(delta):
	if !is_in_contact_with_ball:
		var vertical_speed = linear_velocity.y
		linear_velocity = Vector3(linear_velocity.x,0,linear_velocity.z).normalized() * previous_frame_horizontal_velocity * speed_damp
		linear_velocity.y = vertical_speed
	else:
		linear_velocity= Vector3(linear_velocity.x,0,linear_velocity.z)
	previous_frame_horizontal_velocity = Vector3(linear_velocity.x,0,linear_velocity.z).length()

func _on_area_3d_2_body_entered(body):
	if body.is_in_group("GoldBar"):
		body.queue_free()
		fill_level +=1
		fill_level = clamp(fill_level,0,3)
		$FillMesh.mesh=gold_fill_meshes[fill_level-1]


func _on_body_entered(body):
	if body is Ball:
		is_in_contact_with_ball=true


func _on_body_exited(body):
	if body is Ball:
		is_in_contact_with_ball=false
