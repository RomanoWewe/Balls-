extends AnimatableBody3D
class_name Bridge

@export var debris_scene :PackedScene
@export_range(0,4) var weight_to_break := 4
var weight_current := 0
@export var linked_objects :Array[Node3D] = []

func _on_area_3d_body_entered(body):
	if body is Minecart:
		weight_current+=body.fill_level
		if weight_current >= weight_to_break:
			destroy()


func _on_area_3d_body_exited(body):
	if body is Minecart:
		weight_current-=body.fill_level

func destroy():
	queue_free()
	for obj in linked_objects:
		obj.queue_free()
	if debris_scene!=null:
		var instance = debris_scene.instantiate()
		instance.position = position
		instance.rotation = rotation
		get_parent().add_child(instance)
		instance.owner = owner
