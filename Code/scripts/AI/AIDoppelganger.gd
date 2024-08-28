extends GravitationalObject
class_name Doppelganger

@export var light : Node3D

func _ready() -> void:
	light.call_deferred("reparent",get_parent())

func _process(delta):
	super._process(delta)
	if is_instance_valid(light):
		light.position = position
	if !$RollingSound.playing:
		$RollingSound.play()
	$RollingSound.volume_db = clamp(sqrt(linear_velocity.x*linear_velocity.x+linear_velocity.z*linear_velocity.z)*1.75-65,-80,0)


func _on_body_entered(body: Node) -> void:
	if body is Ball:
		body.hit(self)
