extends MeshInstance3D
class_name BossBody

@export var is_watching :=false
var time :=0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_watching or !%CurrentLevel.has_node("static") or \
		!is_instance_valid(%CurrentLevel/static/Ball):
		return
	time+=delta
	transform.basis=Basis.looking_at(
		-Vector3(global_position.x,0,global_position.z).direction_to(
		Vector3(%CurrentLevel/static/Ball.global_position.x,0,
		%CurrentLevel/static/Ball.global_position.z))).rotated(Vector3.UP,PI/2)
	position.y=6+sin(time*PI/2)
