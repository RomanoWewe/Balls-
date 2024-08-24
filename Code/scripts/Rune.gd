extends Area3D
class_name Rune

@export var preview : Texture2D
var level : Level
var collected:=false

func _ready() -> void:
	level= get_tree().root.get_child(0) as Level

func _on_body_entered(body: Node3D) -> void:
	if !body is Ball or collected:
		return
	
	level.rune_collected(preview)
	queue_free()
