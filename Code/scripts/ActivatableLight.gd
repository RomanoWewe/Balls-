extends Activatable
class_name ActivatableLight

@onready var region: NavigationRegion3D = get_tree().root.get_child(0).get_node("GolemNavigationRegion3D")
@export var light:Light
@export var light_collider : CollisionShape3D

var squeak_alternator := false
var prev_frame_rotation_speed : float
var prev_frame_rotation_speed_change : float

func _ready():
	light.set_light_active(auto_cycling)
	light_collider.disabled=!auto_cycling
	while region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()

func add_steps(_steps : int):
	auto_cycling = !auto_cycling
	light.set_light_active(auto_cycling)
	light_collider.disabled=!auto_cycling
	while region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()

func _physics_process(_delta: float) -> void:
	if !has_node("RigidBody3D"):
		return
	var angular_velocity_change =$RigidBody3D.angular_velocity.x - prev_frame_rotation_speed
	if angular_velocity_change*prev_frame_rotation_speed_change<0 and abs(prev_frame_rotation_speed)>0.005 and abs($RigidBody3D.rotation_degrees.z)<30:
		if squeak_alternator:
			$AudioStreamPlayer1.volume_db = map_speed_to_volume(abs($RigidBody3D.angular_velocity.x))
			$AudioStreamPlayer1.play()
		else:
			$AudioStreamPlayer2.volume_db = map_speed_to_volume(abs($RigidBody3D.angular_velocity.x))
			$AudioStreamPlayer2.play()
		squeak_alternator=!squeak_alternator
	if abs(prev_frame_rotation_speed)<7 and abs($RigidBody3D.angular_velocity.x)>7:
		$AudioStreamPlayer3.play()
	prev_frame_rotation_speed_change=angular_velocity_change
	prev_frame_rotation_speed=$RigidBody3D.angular_velocity.x

func map_speed_to_volume(speed:float) -> float:
	return clamp(speed*5-45,-60,-20)
