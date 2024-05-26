extends AudioStreamPlayer
class_name AmbientSoundPlayer

@export var sounds : Array[AudioStreamWAV]

func _ready():
	if sounds.size()<1:
		return
	autoplay=true
	stream=sounds.pick_random()
	playing=true
	finished.connect(play_random)

func play_random():
	stream=sounds.pick_random()
	playing=true
