extends GravitationalObject
class_name Ball


var amount_of_ground_contacted:=0
var is_destroyed :=false
@export var destroyed_particles = preload("res://Scenes/Objects/_Spawnable/shards.tscn")
@export var move_particles_instance : GPUParticles3D

func _ready():
	move_particles_instance.call_deferred("reparent",get_parent())

func _process(delta):
	super._process(delta)
	move_particles_instance.position = position - Vector3.UP * 1.5
	move_particles_instance.amount_ratio = (linear_velocity.length()/max_speed)
	if is_destroyed:
		return
	if !$RollingSound.playing:
		$RollingSound.play()
	$RollingSound.volume_db = clamp(linear_velocity.length()*1.75-80,-80,0)


func hit(_body : CollisionObject3D):
	if (invincible):
		return
	var rng = RandomNumberGenerator.new()
	
	var shards = destroyed_particles.instantiate()
	get_parent().add_child(shards)
	shards.position = position-Vector3.UP*1.5
	shards.rotation = rotation
	for shard in shards.get_children():
		shard.linear_velocity +=linear_velocity
		shard.angular_velocity = Vector3(rng.randf_range(-10,10),rng.randf_range(-10,10),rng.randf_range(-10,10))
	$DeathSound.start_playing()
	$mesh.queue_free()
	$collider.queue_free()
	$RollingSound.queue_free()
	is_destroyed=true
	get_tree().root.get_child(0).fail_level()
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("IsFloor"):
		amount_of_ground_contacted+=1
		is_affected_by_tilt=true

func _on_body_exited(body):
	if body.is_in_group("IsFloor"):
		amount_of_ground_contacted-=1
		if amount_of_ground_contacted==0:
			is_affected_by_tilt=false
