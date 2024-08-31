extends AnimatableBody3D
class_name LockedDoor

@export var preview : Texture2D
var open :=false
var level :Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = get_tree().root.get_child(0) as Level

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body is Ball or open:
		return
	if level.runes_collected.has(preview):
		level.rune_used(preview)
		$AnimationPlayer.current_animation="Open"
		open=true
		$AudioStreamPlayer1.play()
		await get_tree().create_timer(0.5).timeout
		$AudioStreamPlayer.play()
		await get_tree().create_timer(1.5).timeout
		#level.get_node("GolemNavigationRegion3D").bake_navigation_mesh()
		level.get_node("CultistNavigationRegion3D").bake_navigation_mesh()
