extends StaticBody3D
class_name Altar

@export var preview : Texture2D
@onready var region: NavigationRegion3D = get_tree().root.get_child(0).get_node("GolemNavigationRegion3D")
var level : Level
var collected:=false

func _ready() -> void:
	level= get_tree().root.get_child(0) as Level

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !body is Ball or collected:
		return
	collected=true
	level.rune_collected(preview)
	$AnimationPlayer.current_animation="Collected"
	$AudioStreamPlayer.play()
	$Light.set_light_active(true)
	$StaticBody3D/CollisionShape3D.disabled=true
	region.bake_navigation_mesh()
