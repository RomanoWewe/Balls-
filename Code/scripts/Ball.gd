extends GravitationalObject
class_name Ball

var mesh : Node3D
var amount_of_ground_contacted:=0
var is_destroyed :=false
var level :Level
@export var destroyed_particles = preload("res://Scenes/Objects/_Spawnable/shards.tscn")
@export var light : Node3D

func _ready():
	level = get_tree().root.get_child(0) as Level
	if int(str(level.name))>60:
		light.call_deferred("reparent",get_parent())
	else:
		light.queue_free()
	$Skin.queue_free()
	mesh = load("res://skindata.tres").scenes[load("user://settings.tres").selected_skin].instantiate()
	add_child(mesh)
	

func _process(delta):
	super._process(delta)
	if is_instance_valid(light):
		light.position = position
	if is_destroyed:
		return
	if !$RollingSound.playing:
		$RollingSound.play()
	$RollingSound.volume_db = clamp(sqrt(linear_velocity.x*linear_velocity.x+linear_velocity.z*linear_velocity.z)*2-80,-80,0)


func hit(_body : CollisionObject3D):
	if (invincible):
		return
	var rng = RandomNumberGenerator.new()
	

	level.skins.stats.deaths_total+=1
	if _body.is_in_group("Spikes"):
		level.skins.stats.deaths_by_spikes+=1
	if _body.is_in_group("Cannonball"):
		level.skins.stats.deaths_by_cannon+=1
	if _body.is_in_group("Fall"):
		level.skins.stats.deaths_by_fall+=1
	level.fail_level()
	var shards = destroyed_particles.instantiate()
	get_parent().add_child(shards)
	shards.position = position-Vector3.UP*1.5
	shards.rotation = rotation
	for shard in shards.get_children():
		if !shard is GravitationalObject:
			shard.emitting = true
			continue
		shard.linear_velocity +=linear_velocity
		shard.angular_velocity = Vector3(rng.randf_range(-10,10),rng.randf_range(-10,10),rng.randf_range(-10,10))
	$DeathSound.start_playing()
	mesh.queue_free()
	$collider.queue_free()
	$RollingSound.queue_free()
	is_destroyed=true
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
