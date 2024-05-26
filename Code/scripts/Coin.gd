extends Area3D
class_name Coin



func _on_body_entered(body):
	if body is Ball:
		get_tree().root.get_child(0).level_data.coin_collected = true
		queue_free()
