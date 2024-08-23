extends Activatable
class_name ActivatableLight

@onready var region: NavigationRegion3D = get_parent()

func _ready():
	$Light.set_light_active(auto_cycling)
	$CollisionShape3D.disabled=!auto_cycling
	if region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()

func add_steps(steps : int):
	auto_cycling = !auto_cycling
	$Light.set_light_active(auto_cycling)
	$CollisionShape3D.disabled=!auto_cycling
	if region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()
