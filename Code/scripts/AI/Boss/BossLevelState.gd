extends BossState
class_name BossLevelState

@export var scenes :Array[PackedScene]
@export var empty_scene :PackedScene
@export var rune_use_animation_name:="rune2"
@export var boulder_surface_material:StandardMaterial3D
@export var boulder_default_material:StandardMaterial3D
func update(_delta)->void:
	pass

func enter()->void:
	%WhooshSound.play()
	fade_out(%MainCamera)
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_surface_material)
	await get_tree().create_timer(2).timeout
	%CurrentLevel.get_node("static").queue_free()
	var new_scene=get_random_scene().instantiate()
	for child in new_scene.get_children():
		if child is AIGolem or child is AICultist:
			child.ball=new_scene.get_node("Ball")
	%CurrentLevel.add_child(new_scene)
	await get_tree().create_timer(0.1).timeout
	new_scene.name="static"
	if !%GolemNavigationRegion3D.is_baking():
		%GolemNavigationRegion3D.bake_navigation_mesh()
	if !%CultistNavigationRegion3D.is_baking():
		%CultistNavigationRegion3D.bake_navigation_mesh()
	fade_in(%MainCamera)
	await get_tree().create_timer(2).timeout

func exit():
	for child in %CurrentLevel.get_node("static").get_children():
		if child is AICultist or child is AIGolem or child is AIDoppelghanger:
			child.process_mode=Node.PROCESS_MODE_DISABLED
	fade_out(%MainCamera)
	await get_tree().create_timer(2).timeout
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_default_material)
	%CurrentLevel.get_node("static").queue_free()
	var new_scene=empty_scene.instantiate()
	%CurrentLevel.add_child(new_scene)
	await await get_tree().create_timer(0.1).timeout
	new_scene.name="static"
	%GolemNavigationRegion3D.bake_navigation_mesh()
	%CultistNavigationRegion3D.bake_navigation_mesh()
	fade_in(%MainCamera)
	await get_tree().create_timer(2).timeout

func on_rune_used()->void:
	%RuneUseAnimator.current_animation=rune_use_animation_name
	exit()
	await get_tree().create_timer(4).timeout
	transfer_state.emit()

func get_random_scene(): return scenes[RandomNumberGenerator.new().randi_range(0,scenes.size()-1)]
