extends Node
class_name SoundQueue

@export var sound : PackedScene
@export var queue_count := 8

var index = 0

func _ready():
	for _i in range(queue_count):
		add_child(sound.instantiate())
		
func get_next_particle():
	return get_child(index)
	
func trigger():
	get_next_particle().start_playing()
	index = (index + 1) % queue_count
