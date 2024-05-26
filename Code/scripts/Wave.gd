extends Area3D
class_name Wave

@export var direction :Vector3
@export var speed := 3.0


func _process(delta):
	position += speed * delta * direction

func _on_body_entered(body):
	if body is GravitationalObject:
		return
	if body is Water:
		body.wave_count +=1
	queue_free()


func _on_body_exited(body):
	if body is Water:
		body.wave_count -=1
