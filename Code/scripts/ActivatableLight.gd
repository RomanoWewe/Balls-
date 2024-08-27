extends Activatable
class_name ActivatableLight

@onready var region: NavigationRegion3D = get_tree().root.get_child(0).get_node("GolemNavigationRegion3D")
@export var light:Light
@export var light_collider : CollisionShape3D

func _ready():
	light.set_light_active(auto_cycling)
	light_collider.disabled=!auto_cycling
	if region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()

func add_steps(_steps : int):
	auto_cycling = !auto_cycling
	light.set_light_active(auto_cycling)
	light_collider.disabled=!auto_cycling
	if region.is_baking():
		await region.bake_finished
	region.bake_navigation_mesh()
