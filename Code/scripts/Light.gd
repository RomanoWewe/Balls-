extends Area3D
class_name Light

@export var is_active :bool
@export var light : Light3D
var angels_inside:=[]

func _ready() -> void:
	if light:
		light.visible=is_active

func _on_body_entered(body):
	if body is AIGolem:
		if is_active:
			body.lights_count+=1
		angels_inside.append(body)


func _on_body_exited(body):
	if body is AIGolem:
		if is_active:
			body.lights_count-=1
		angels_inside.erase(body)

func set_light_active(value:bool):
	is_active=value
	if light:
		light.visible=is_active
	if is_active:
		for angel in angels_inside:
			angel.lights_count+=1
	else:
		for angel in angels_inside:
			angel.lights_count-=1
