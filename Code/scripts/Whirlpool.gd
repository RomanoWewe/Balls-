@tool
extends Water
class_name Whirlpool

static var current_audio_instance : AudioStreamPlayer
var audio_prefab :PackedScene = preload("res://Scenes/Objects/_Spawnable/flow_heavy.tscn")
@export var pull_force := 1.0

func set_visible_visuals(new_value:bool):
	super.set_visible_visuals(new_value)
	$MovingPlatform.visible=new_value

func _ready():
	super._ready()
	if (current_audio_instance==null):
		current_audio_instance=audio_prefab.instantiate()
		call_deferred("add_sibling",current_audio_instance)
		current_audio_instance.set_deferred("owner",get_tree().root)

func _physics_process(delta):
	for body in bodies_affected:
		body.linear_velocity *= LINEAR_DAMP
		body.apply_force(get_body_submerge_percentage(body)*body.mass*
		Vector3.DOWN*pull_force)
