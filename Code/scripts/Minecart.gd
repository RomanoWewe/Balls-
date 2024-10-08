extends RigidBody3D
class_name Minecart

@export var max_speed := 10
@export var fill_level := 0
@export var gold_fill_meshes :Array[ArrayMesh] = []
@export var speed_damp :=0.997
@export var bounce := 0.5
@export var invincible :=false
var contacted_bodies := []
var previous_frame_horizontal_velocity := Vector3.ZERO

func _ready():
	if fill_level>0:
		$FillMesh.mesh=gold_fill_meshes[fill_level-1]

func _physics_process(delta):
	if freeze:
		return
	if contacted_bodies.size()==0:
		var vertical_speed = linear_velocity.y
		linear_velocity = Vector3(linear_velocity.x,0,linear_velocity.z).normalized() * previous_frame_horizontal_velocity.length() * speed_damp
		if linear_velocity.length()<5:
			linear_velocity*=0.99
		if linear_velocity.angle_to(previous_frame_horizontal_velocity)>PI/3:
			linear_velocity*=bounce
		linear_velocity.y = vertical_speed
	else:
		linear_velocity= Vector3(linear_velocity.x,0,linear_velocity.z)
	previous_frame_horizontal_velocity = Vector3(linear_velocity.x,0,linear_velocity.z)
	if !$RollingSound.playing:
		$RollingSound.play()
	$RollingSound.volume_db = clamp(linear_velocity.length()*2-75,-80,0)

func _on_area_3d_2_body_entered(body):
	if body.is_in_group("GoldBar"):
		body.queue_free()
		fill_level +=1
		fill_level = clamp(fill_level,0,3)
		$FillMesh.mesh=gold_fill_meshes[fill_level-1]


func _on_body_entered(body):
	if body is GravitationalObject:
		contacted_bodies.append(body)


func _on_body_exited(body):
	if body in contacted_bodies:
		contacted_bodies.erase(body)

func make_invincible(seconds:float):
	invincible = true
	await get_tree().create_timer(seconds).timeout
	invincible=false
