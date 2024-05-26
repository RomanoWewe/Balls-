@tool
extends Activatable
class_name ActivatableSound

@export var activate_sound : AudioStream
@export var deactivate_sound : AudioStream
@export var active :=false
@export var bus :="Sound"
@export var volume :=-20.0

func _ready():
	add_child(AudioStreamPlayer.new(),true)
	get_child(0).name = "activateSound"
	add_child(AudioStreamPlayer.new(),true)
	get_child(1).name = "deactivateSound"
	$activateSound.volume_db=volume
	$deactivateSound.volume_db=volume
	$activateSound.stream=activate_sound
	$deactivateSound.stream=deactivate_sound
	$activateSound.bus = bus
	$deactivateSound.bus = bus

func set_active(value: bool):
	if !is_inside_tree():
		return
	super.set_active(value)
	if auto_cycling:
		$activateSound.playing=true
		$deactivateSound.playing=false
	else:
		$deactivateSound.playing=true
		$activateSound.playing=false

func add_steps(steps : int):
	if !is_inside_tree():
		return
	steps_left +=steps
	active = !active
	if active:
		$activateSound.playing=true
		$deactivateSound.playing=false
	else:
		$deactivateSound.playing=true
		$activateSound.playing=false
