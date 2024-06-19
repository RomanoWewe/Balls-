extends StaticBody3D
class_name GoldConveyor

@export var gold_bar_prefab : PackedScene
@export var spawn_point :Node3D
@export var spawn_cooldown : float
var since_last_spawn :=0.0

func _ready():
	$AnimationPlayer.current_animation="new_animation"

func _process(delta):
	since_last_spawn +=delta
	if since_last_spawn>spawn_cooldown:
		spawn()

func spawn():
	since_last_spawn = 0
	var instance  = gold_bar_prefab.instantiate() as Node3D
	add_child(instance)
	instance.global_position = spawn_point.global_position
	instance.global_basis = global_basis.rotated(Vector3.UP,PI/2)
