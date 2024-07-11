@tool
extends Activatable
class_name HoleWildWest

@export var exploded_mesh : Mesh
@export var debris_scene : PackedScene
var is_exploded :=false

func add_steps(_steps):
	if is_exploded:
		return
	is_exploded = true
	$Block.queue_free()
	$MeshInstance3D.mesh = exploded_mesh
	var debris = debris_scene.instantiate() as Node3D
	debris.position = position
	debris.rotation = rotation
	add_sibling(debris)
	debris.owner = owner
	for child in debris.get_children():
		child.linear_velocity = -25* transform.basis.x
