extends Area3D
class_name KillZone

@export var destroy_parent_on_contact :=false
@export var destroy_self_on_contact :=false
var ignore_list :Array[Node3D] = []


func _on_body_entered(body):
	if body in ignore_list:
		return
	if body is Ball:
		body.hit(self)
	if (destroy_parent_on_contact):
		get_parent().call_deferred("queue_free")
	elif (destroy_self_on_contact):
		call_deferred("queue_free")

