@tool
extends Water
class_name WaterCurrent

static var current_audio_instance : AudioStreamPlayer
var audio_prefab :PackedScene = preload("res://Scenes/Objects/_Spawnable/flow.tscn")
@export var current_direction :Vector3 :set = set_current_direction
@export var current_power := 10.0
@export var show_wave :=true
@export var wave_speed := 1.0
@export var scale_wave_speed_by_current_power :=true
var visualizer : Visualizer 
@export var wave_instance :Node3D
var rng :RandomNumberGenerator
const WAVE_SPEED_MULTIPLIER := 6.0

func set_visible_visuals(new_value:bool):
	super.set_visible_visuals(new_value)

func _ready():
	rng = RandomNumberGenerator.new()
	aabb = $mesh2.get_aabb()
	aabb.position+=$mesh2.position+position
	if Engine.is_editor_hint():
		if visualizer:
			visualizer.queue_free()
		visualizer = Visualizer.new()
		add_sibling.call_deferred(visualizer)
		call_deferred("draw_editor_visuals")
	else:
		if (current_audio_instance==null):
			current_audio_instance=audio_prefab.instantiate()
			call_deferred("add_sibling",current_audio_instance)
			current_audio_instance.set_deferred("owner",get_tree().root)
		if visualizer:
			visualizer.clear_active_meshes()
			visualizer.queue_free()
			visualizer=null
		if current_direction != Vector3() and show_wave:
			wave_instance.global_transform=wave_instance.global_transform.looking_at((current_direction).rotated(Vector3.UP,PI/2)+global_transform.origin+Vector3.UP*5)
			if scale_wave_speed_by_current_power:
				wave_instance.get_child(0).scale_movement_times(wave_speed*WAVE_SPEED_MULTIPLIER/current_power)
			else:
				wave_instance.get_child(0).scale_movement_times(wave_speed*WAVE_SPEED_MULTIPLIER)
		else:
			wave_instance.queue_free()


func _physics_process(delta):
	for body in bodies_affected:
		body.linear_velocity *= LINEAR_DAMP
		body.apply_force(get_body_submerge_percentage(body)*body.mass*
		Vector3.UP*body.buoyancy*body.gravity_scale*9.8)
		body.apply_force(body.mass*current_direction*current_power)

func set_current_direction(new_val:Vector3):
	current_direction = new_val.normalized()
	draw_editor_visuals()

func draw_editor_visuals():
	if !(visualizer):
		return
	visualizer.clear_active_meshes()
	visualizer.draw_point(position+Vector3.UP*5.1)
	visualizer.draw_line(position+Vector3.UP*5.1,position+Vector3.UP*5.1+current_direction)
	visualizer.draw_point(position+Vector3.UP*5.1+current_direction,0.2,Color.RED)

func _exit_tree():
	if visualizer and is_instance_valid(visualizer):
		visualizer.clear_active_meshes()
		visualizer.queue_free()
