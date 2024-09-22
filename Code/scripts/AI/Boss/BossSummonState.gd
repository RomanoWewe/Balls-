extends BossState
class_name BossSummonState

@export_subgroup("Spawn settings")
@export var golem_spawn_min_count:int
@export var golem_spawn_max_count:int
@export var cultist_spawn_min_count:int
@export var cultist_spawn_max_count:int
@export var doppelghanger_spawn_min_count:int
@export var doppelghanger_spawn_max_count:int
@export var cultist_min_speed :float
@export var cultist_max_speed :float
@export var spawn_delay: float

var golem_prefab:= preload("res://Scenes/Objects/BuildingBlocks/Cave/GolemCave.tscn")
var cultist_prefab :=preload("res://Scenes/Objects/BuildingBlocks/Cave/CultistCave.tscn")
var doppelghanger_prefab:=preload("res://Scenes/Objects/BuildingBlocks/Cave/DoppelgangerCave.tscn")

func enter()->void:
	super.enter()
	var rnd=RandomNumberGenerator.new()
	
	var golem_spawn_count=rnd.randi_range(golem_spawn_min_count,
		golem_spawn_max_count)
	var cultist_spawn_count=rnd.randi_range(cultist_spawn_min_count,
		cultist_spawn_max_count)
	var doppelghanger_spawn_count=rnd.randi_range(doppelghanger_spawn_min_count,
		doppelghanger_spawn_max_count)
	while true:
		await get_tree().create_timer(spawn_delay).timeout
		var randomized_spawns:=[]
		if golem_spawn_count>0:
			randomized_spawns.append("golem")
		if cultist_spawn_count>0:
			randomized_spawns.append("cultist")
		if doppelghanger_spawn_count>0:
			randomized_spawns.append("doppelghanger")
			
		if randomized_spawns.size()<1:
			break
		var selected_spawn = randomized_spawns[rnd.randi_range(0,randomized_spawns.size()-1)]
		if selected_spawn=="golem":
			golem_spawn_count-=1
			fade_in(golem_prefab.instantiate())
		if selected_spawn=="cultist":
			cultist_spawn_count-=1
			var cultist=cultist_prefab.instantiate() as AICultist
			cultist.speed=rnd.randf_range(cultist_min_speed,cultist_max_speed)
			fade_in(cultist)
		if selected_spawn=="doppelghanger":
			doppelghanger_spawn_count-=1
			fade_in(doppelghanger_prefab.instantiate())

func exit()->void:
	is_ready=false
	for child in get_children():
		if child is AICultist or child is AIGolem or child is AIDoppelghanger:
			fade_out(child)
	await get_tree().create_timer(2).timeout
	transfer_state.emit()

func get_random_spawn_position()->Vector3:
	var rng= RandomNumberGenerator.new()
	
	if rng.randi_range(0,4)==0:
		return get_random_point_in_area(%SummonMarkers/MainArea)
	elif rng.randi_range(0,1)==0:
		return get_random_point_in_area(%SummonMarkers/LeftSmallArea)
	else:
		return get_random_point_in_area(%SummonMarkers/RightSmallArea)

func get_random_point_in_area(area_node)->Vector3:
	var rng=RandomNumberGenerator.new()
	var x= rng.randf_range(area_node.get_node("LeftUp").global_position.x,
		area_node.get_node("RightDown").global_position.x)
	var z= rng.randf_range(area_node.get_node("LeftUp").global_position.z,
		area_node.get_node("RightDown").global_position.z)
	var y= rng.randf_range(area_node.get_node("LeftUp").global_position.y,
		area_node.get_node("RightDown").global_position.y)
	return Vector3(x,y,z)

func fade_in(instance:Node3D):
	add_child(instance)
	instance.position= get_random_spawn_position()
	instance.process_mode=Node.PROCESS_MODE_DISABLED
	var t=0.0
	while t<1:
		instance.get_node("MeshInstance3D").transparency=1-t
		await get_tree().create_timer(0.02).timeout
		t+=.01
	instance.process_mode=Node.PROCESS_MODE_INHERIT

func fade_out(instance:Node3D):
	instance.process_mode=Node.PROCESS_MODE_DISABLED
	var t=0.0
	while t<1:
		instance.get_node("MeshInstance3D").transparency=t
		await get_tree().create_timer(0.02).timeout
		t+=.01
	instance.queue_free()
