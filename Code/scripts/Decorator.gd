@tool
extends Node3D
class_name Decorator

@export var is_enabled := true : set=set_is_enabled
@export var mean := 2.0
@export var deviation :=1.0
@export var decorations : Array[PackedScene] 
@export var spawn_chances : Array[int] : set = recalculate_spawn_chances
@export var spawn_chances_cumulative : Array[int]
@export var position_extents :=Vector3(5,0,5)
@export var regenerate_decorations : bool : set= generate_decorations_func
@export var regenerate_all_decorations : bool : set= generate_all_decorations_func
static var decorators := []


func _ready():
	decorators.append(self)
	generate_decorations_func(true)
	

func recalculate_spawn_chances(new_val : Array[int]):
	spawn_chances = new_val
	spawn_chances_cumulative =[]
	var current=0
	for chance in spawn_chances:
		current += chance
		spawn_chances_cumulative.append(current)

func set_is_enabled(new_val : bool):
	is_enabled = new_val
	generate_decorations_func(true)

func generate_decorations_func(_new_val : bool):
	for child in get_children():
		child.queue_free()
	if decorations.size()==0 or !is_enabled :
		return
	var spawn_count = int(randfn(mean,deviation))
	for i in range(0,spawn_count):
		spawn_random_decoration()

func spawn_random_decoration():
	var selected_number = randi_range(0,spawn_chances_cumulative.back())
	var selected_index = 0
	while spawn_chances_cumulative[selected_index]<selected_number:
		selected_index+=1
	var selected_decoration = decorations[selected_index] as PackedScene
	var instance = selected_decoration.instantiate() as Node3D
	add_child(instance)
	instance.position = Vector3(randf_range(-position_extents.x, position_extents.x),randf_range(-position_extents.y, position_extents.y),randf_range(-position_extents.z, position_extents.z))
	instance.rotation.y = PI/2 * randi_range(0,3)

func generate_all_decorations_func(_new_val : bool):
	for decorator in decorators:
		if get_tree().get_edited_scene_root().is_ancestor_of(decorator):
			decorator.generate_decorations_func(true)

func _on_tree_exiting():
	decorators.erase(self)
