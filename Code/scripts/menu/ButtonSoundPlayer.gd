extends AudioStreamPlayer
class_name ButtonSoundPlayer

@export var signal_name : String

func _ready():
	get_parent().connect(signal_name,play)
