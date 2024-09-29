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
@export_subgroup("Boulder material")
@export var boulder_surface_material:StandardMaterial3D
@export var boulder_default_material:StandardMaterial3D
var golem_prefab:= preload("res://Scenes/Objects/BuildingBlocks/Cave/GolemCave.tscn")
var cultist_prefab :=preload("res://Scenes/Objects/BuildingBlocks/Cave/CultistCave.tscn")
var doppelghanger_prefab:=preload("res://Scenes/Objects/BuildingBlocks/Cave/DoppelgangerCave.tscn")

func enter()->void:
	super.enter()
	%WhooshSound.play()
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_surface_material)
	var rng=RandomNumberGenerator.new()
	
	var golem_spawn_count=rng.randi_range(golem_spawn_min_count,
		golem_spawn_max_count)
	var cultist_spawn_count=rng.randi_range(cultist_spawn_min_count,
		cultist_spawn_max_count)
	var doppelghanger_spawn_count=rng.randi_range(doppelghanger_spawn_min_count,
		doppelghanger_spawn_max_count)
	while true:
		await get_tree().create_timer(rng.randf_range(spawn_delay/2,spawn_delay*2)).timeout
		var randomized_spawns:=[]
		if golem_spawn_count>0:
			randomized_spawns.append("golem")
		if cultist_spawn_count>0:
			randomized_spawns.append("cultist")
		if doppelghanger_spawn_count>0:
			randomized_spawns.append("doppelghanger")
			
		if randomized_spawns.size()<1:
			break
		%Summon.trigger()
		var selected_spawn = randomized_spawns[rng.randi_range(0,randomized_spawns.size()-1)]
		if selected_spawn=="golem":
			golem_spawn_count-=1
			var instance=golem_prefab.instantiate()
			instance.ball=%CurrentLevel.get_node("static/Ball")
			add_child(instance)
			instance.position= get_random_spawn_position()
			fade_in(instance)
		if selected_spawn=="cultist":
			cultist_spawn_count-=1
			var instance=cultist_prefab.instantiate() as AICultist
			instance.ball=%CurrentLevel.get_node("static/Ball")
			instance.speed=rng.randf_range(cultist_min_speed,cultist_max_speed)
			add_child(instance)
			instance.position= get_random_spawn_position()
			fade_in(instance)
		if selected_spawn=="doppelghanger":
			doppelghanger_spawn_count-=1
			var instance=doppelghanger_prefab.instantiate()
			add_child(instance)
			instance.position= get_random_spawn_position()
			fade_in(instance)

func exit()->void:
	is_ready=false
	for child in get_children():
		if child is AICultist or child is AIGolem or child is AIDoppelghanger or child is Light3D or child is Light:
			fade_out(child)
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_default_material)
	await get_tree().create_timer(2).timeout
	transfer_state.emit()

func get_random_spawn_position()->Vector3:
	var rng= RandomNumberGenerator.new()
	
	if rng.randi_range(0,10)==0:
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
