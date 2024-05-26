extends Area3D
class_name Hole



func _on_body_entered(body):
	if body is Ball:
		get_tree().root.get_child(0).complete_level()
		body.invincible = true
