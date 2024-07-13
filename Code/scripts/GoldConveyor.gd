extends StaticBody3D
class_name GoldConveyor

@export var gold_bar_prefab : PackedScene
@export var spawn_point :Node3D
@export var spawn_cooldown : float
var since_last_spawn :=0.0

func _ready():
	$AnimationPlayer.current_animation="new_animation"
	var angle = basis.x.signed_angle_to(Vector3.RIGHT,Vector3.DOWN)
	$WaterCurrent.current_direction = $WaterCurrent.current_direction.rotated(Vector3.UP,angle)
	$WaterCurrent2.current_direction = $WaterCurrent2.current_direction.rotated(Vector3.UP,angle)

func _process(delta):
	since_last_spawn +=delta
	if since_last_spawn>spawn_cooldown and $AreaTracker.objects_in_area.size()>0:
		spawn()

func spawn():
	since_last_spawn = 0
	var instance  = gold_bar_prefab.instantiate() as Node3D
	add_child(instance)
	instance.global_position = spawn_point.global_position
	instance.global_basis = global_basis.rotated(Vector3.UP,PI/2)
