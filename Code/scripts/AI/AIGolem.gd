extends RigidBody3D
class_name AIGolem

@export var speed = 10
@export var accel = 10
@export var stop_range = 10

# the vars which make you do the thing where you do the thing
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var ball: Ball
var lights_count:=0

func _ready():
	$AnimationPlayer.current_animation="RESET"
	for child in get_parent().get_children():
		if child is Ball:
			ball=child
			return
	push_error("Ball Not found on level!")

# the stupid physics stuff
func _physics_process(delta):
	if !NavigationServer3D.map_is_active(RID(agent.get_navigation_map())):
		$AudioStreamPlayer.volume_db=lerp($AudioStreamPlayer.volume_db,-80.0,0.5)
		return
	
	agent.target_position = ball.global_position # this one needs the @onready vars we defined earlier

	
	if lights_count>0 or agent.is_navigation_finished():
		$AudioStreamPlayer.volume_db=lerp($AudioStreamPlayer.volume_db,-80.0,0.5)
		stop()
		return
	$AudioStreamPlayer.volume_db=lerp($AudioStreamPlayer.volume_db,-20.0,0.5)
	var direction = Vector3()
	direction = agent.get_next_path_position() - position # and so does this
	move()
	direction = direction.normalized()
	basis=basis.rotated(Vector3.UP, basis.z.signed_angle_to(direction,Vector3.UP))
	var new_velocity
	if accel>0:
		new_velocity = linear_velocity.lerp(direction * speed, accel * delta)
	else:
		new_velocity = direction * speed
	agent.set_velocity(new_velocity)


func stop():
	axis_lock_linear_x=true
	axis_lock_linear_y=true
	axis_lock_linear_z=true

func move():
	axis_lock_linear_x=false
	axis_lock_linear_y=false
	axis_lock_linear_z=false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Ball:
		$AnimationPlayer.current_animation="TurnOn"


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Ball:
		$AnimationPlayer.current_animation="TurnOff"


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	linear_velocity = safe_velocity
