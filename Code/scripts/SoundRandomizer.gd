@tool
extends AudioStreamPlayer
class_name SoundRandomizer

@export var randomizing_enabled := false
@export_category("Randomizing")
@export var play_random_sound : bool =false: set = start_playing
@export var randomize_sound :=false
@export var base_name : String
@export var sounds_amount : int
@export var randomize_volume :=false
@export var volume_range :Vector2 = Vector2(0,0)
@export var randomize_pitch :=true
@export var pitch_range :Vector2 = Vector2(1,1)

func start_playing(_new_val : bool = false):
	if  (randomizing_enabled):
		if randomize_sound:
			var name_to_play = base_name+str(randi_range(1,sounds_amount))
			stream = load("res://Assets/Sounds/"+name_to_play+".wav")
		if randomize_pitch:
			pitch_scale = randf_range(pitch_range.x,pitch_range.y)
		if randomize_volume:
			volume_db = randf_range(volume_range.x,volume_range.y)
	play() 
