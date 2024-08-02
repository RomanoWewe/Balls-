extends Node3D
class_name ParticleQueue

@export var particle : PackedScene
@export var queue_count := 8

var index = 0

func _ready():
	for _i in range(queue_count):
		add_child(particle.instantiate())
		
func get_next_particle():
	return get_child(index)
	
func trigger():
	get_next_particle().restart()
	index = (index + 1) % queue_count
