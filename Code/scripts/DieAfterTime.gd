extends Node
class_name DieAfterTime
@export var time_seconds :float = 0


func _ready():
	await get_tree().create_timer(time_seconds).timeout
	get_parent().queue_free()
