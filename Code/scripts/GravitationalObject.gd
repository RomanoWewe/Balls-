extends RigidBody3D
class_name GravitationalObject

var invincible := false
var waters_intersected := []

@export var buoyancy := .9
@export var gravity_force : float = 5000
@export var is_affected_by_tilt := false

var tilt_x : float
var tilt_z : float

@export var max_tilt_x : float = 80
@export var max_tilt_z : float = 80

@export var max_speed : float =20

var prev_frame_velocity : Vector3 = Vector3()

func _physics_process(delta):
	if is_affected_by_tilt:
		apply_force(Vector3(sin(deg_to_rad(tilt_x))*gravity_force*delta,0,sin(deg_to_rad(tilt_z))*gravity_force*delta))
		var vec2 = Vector2(linear_velocity.x,linear_velocity.z).limit_length(max_speed)
		linear_velocity = Vector3(vec2.x,linear_velocity.y,vec2.y)
	if (linear_velocity-prev_frame_velocity).length()>10 and has_node("HitSound"):
		$HitSound.volume_db = (linear_velocity-prev_frame_velocity).length()*2-60
		$HitSound.play()
	prev_frame_velocity=linear_velocity

func _process(_delta):
	if Input.is_action_pressed("press_down") and not Input.is_action_pressed("press_up"):
		tilt_z=max_tilt_z
	elif Input.is_action_pressed("press_up") and not Input.is_action_pressed("press_down"):
		tilt_z=-max_tilt_z
	else: 
		tilt_z = 0
	if Input.is_action_pressed("press_left") and not Input.is_action_pressed("press_right"):
		tilt_x=-max_tilt_x
	elif Input.is_action_pressed("press_right") and not Input.is_action_pressed("press_left"):
		tilt_x=max_tilt_x
	else: 
		tilt_x = 0

func make_invincible(seconds:float):
	invincible = true
	await get_tree().create_timer(seconds).timeout
	invincible=false

