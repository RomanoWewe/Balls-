extends Node3D
class_name Rail

@export_flags("1","2","3","4","5") var catch_mask := 1
@export_flags("1","2","3","4","5") var release_mask := 1

func _on_area_3d_area_entered(area):
	var area_parent = area.get_parent()
	if not area_parent is Minecart:
		return
	area_parent.try_set_rail(self)
	
func _on_area_3d_area_exited(area):
	var area_parent = area.get_parent()
	if not area_parent is Minecart:
		return
	area_parent.try_unset_rail(self)

func get_minecart_direction(_minecart):
	return global_basis
