extends BossState
class_name BossLevelState

@export var scenes :Array[PackedScene]
@export var empty_scene :PackedScene

func update(_delta)->void:
	pass

func enter()->void:
	fade_out(%MainCamera)
	await get_tree().create_timer(2).timeout
	%CurrentLevel.get_node("static").queue_free()
	var new_scene=get_random_scene().instantiate()
	for child in new_scene.get_children():
		if child is AIGolem or child is AICultist:
			child.ball=new_scene.get_node("Ball")
	%CurrentLevel.add_child(new_scene)
	await get_tree().create_timer(0.1).timeout
	if !%GolemNavigationRegion3D.is_baking():
		%GolemNavigationRegion3D.bake_navigation_mesh()
	if !%CultistNavigationRegion3D.is_baking():
		%CultistNavigationRegion3D.bake_navigation_mesh()
	fade_in(%MainCamera)
	await get_tree().create_timer(2).timeout
	new_scene.name="static"

func exit():
	for child in %CurrentLevel.get_node("static").get_children():
		child.process_mode=Node.PROCESS_MODE_DISABLED
	fade_out(%MainCamera)
	await get_tree().create_timer(2).timeout
	%CurrentLevel.get_node("static").queue_free()
	var new_scene=empty_scene.instantiate()
	%CurrentLevel.add_child(new_scene)
	await await get_tree().create_timer(0.1).timeout
	%GolemNavigationRegion3D.bake_navigation_mesh()
	%CultistNavigationRegion3D.bake_navigation_mesh()
	fade_in(%MainCamera)
	await get_tree().create_timer(2).timeout
	new_scene.name="static"

func on_rune_used()->void:
	exit()
	await get_tree().create_timer(4).timeout
	transfer_state.emit()

func get_random_scene(): return scenes[RandomNumberGenerator.new().randi_range(0,scenes.size()-1)]
