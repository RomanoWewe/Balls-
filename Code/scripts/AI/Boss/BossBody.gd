extends Node3D
class_name BossBody
@export var is_active :=true
@export var is_watching :=false
var time :=0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_active:
		return
	if !is_watching or !%CurrentLevel.has_node("static") or \
		!%CurrentLevel/static.has_node("Ball"):
		transform.basis=transform.basis.slerp(Basis.IDENTITY,0.01)
		return
	time+=delta
	transform.basis=transform.basis.slerp(Basis.looking_at(
		-Vector3(global_position.x,0,global_position.z).direction_to(
		Vector3(%CurrentLevel/static/Ball.global_position.x,0,
		%CurrentLevel/static/Ball.global_position.z))).rotated(Vector3.UP,PI/2),0.01)
	position.y=17+sin(time*PI/2)
