extends Activatable
class_name Cannon


@export var time_until_shot := 0.0
@export var reload_time := 2.0
@export var projectile_speed :=5.0
@onready var cannonball_prefab = preload("res://Scenes/Objects/_Spawnable/cannonball.tscn")

func _process(delta):
	if (!auto_cycling and steps_left<1):
		return
	time_until_shot-=delta
	if time_until_shot<=0:
		time_until_shot=reload_time
		shot()
		if (!auto_cycling):
			steps_left-=1

func shot():
	$SoundQueue.trigger()
	var instance = cannonball_prefab.instantiate() as Projectile
	instance.position = $ParticleQueue.global_position
	$ParticleQueue.trigger()
	add_sibling(instance)
	instance.linear_velocity = -get_global_transform().basis.x*projectile_speed
	instance.angular_velocity = Vector3(randf_range(-10,10),randf_range(-10,10),randf_range(-10,10)).normalized()*20
	instance.add_ignore(self)
