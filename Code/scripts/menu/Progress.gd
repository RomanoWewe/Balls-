extends Resource
class_name Progress

@export var level_completion_data : Array[bool]

func _init():
	level_completion_data = []
	for i in range(129):
		level_completion_data.append(false)
	level_completion_data[0]= true


