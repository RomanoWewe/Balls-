extends RigidBody3D
class_name Boulder

@export var base_position :Marker3D
@export var is_running :=false
var base_speed:=1.0
var rng : RandomNumberGenerator
func _ready() -> void:
	pass # Replace with function body.

func activate():
	rng = RandomNumberGenerator.new()
	is_running=true
	$CollisionShape3D.disabled=false
	freeze=false
	linear_velocity= (%CurrentLevel.get_node("static/Ball").global_position-global_position).normalized()*base_speed*50.0
	$AnimationPlayer.current_animation="rotating"
	$ThrowSound.play()

func deactivate():
	print(name+ " deactivated")
	is_running=false
	$CollisionShape3D.disabled=true
	freeze=true
	linear_velocity=Vector3.ZERO

func return_to_base():
	is_running=false
	$CollisionShape3D.disabled=true
	freeze=true
	linear_velocity=Vector3.ZERO
	var t=0.0
	var start_position = global_position
	while t<1:
		global_position=start_position.slerp(base_position.global_position,t)
		t+=0.02
		await get_tree().create_timer(0.02).timeout
	get_node("AnimationPlayer").current_animation="exit"

func _on_body_entered(body: Node) -> void:
	if !is_instance_valid(%CurrentLevel.get_node("static/Ball")):
		return
	if body is Ball:
		body.hit(self)
	if !is_running or freeze:
		return
	if !body is Boulder and !body.is_in_group("IsFloor"):
		is_running=false
		linear_velocity=Vector3.ZERO
		angular_velocity=Vector3.ZERO
		await get_tree().create_timer(rng.randf_range(0.5/base_speed,1.5/base_speed)).timeout
		if freeze:
			return
		is_running=true
		linear_velocity= (%CurrentLevel.get_node("static/Ball").global_position-global_position).normalized()*base_speed*50
		$ThrowSound.play()
