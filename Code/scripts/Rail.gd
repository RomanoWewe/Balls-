extends Node3D
class_name Rail

@export var catch_minecart :=true

func _on_area_3d_area_entered(area):
	if !catch_minecart:
		return
	var area_parent = area.get_parent()
	if not area_parent is Minecart:
		return
	area_parent.set_rail(self)

func get_minecart_direction(_minecart):
	return global_basis


func _on_area_3d_body_entered(body):
	if !catch_minecart:
		return
	var area_parent = body.get_parent()
	if not area_parent is Minecart:
		return
	print(body)
	area_parent.set_rail(self)
