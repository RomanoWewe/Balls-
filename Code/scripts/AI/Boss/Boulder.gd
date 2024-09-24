extends RigidBody3D
class_name Boulder

@export var base_position :Marker3D
@export var is_running :=false
var base_speed:=1

func _ready() -> void:
	pass # Replace with function body.

func activate():
	is_running=true
	$CollisionShape3D.disabled=false
	freeze=false
	linear_velocity= (%CurrentLevel.get_node("static/Ball").global_position-global_position).normalized()*base_speed*50

func return_to_base():
	is_running=false
	$CollisionShape3D.disabled=true
	freeze=true
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
	if !is_running:
			return
	if body is Ball:
		body.hit(self)
	if !body is Boulder and !body.is_in_group("IsFloor"):
		linear_velocity=Vector3.ZERO
		angular_velocity=Vector3.ZERO
		await get_tree().create_timer(1.0/base_speed/1.5).timeout
		if !is_running:
			return
		linear_velocity= (%CurrentLevel.get_node("static/Ball").global_position-global_position).normalized()*base_speed*50
	
