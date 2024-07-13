extends AnimatableBody3D
class_name Bridge

@export var debris_scene :PackedScene
@export_range(0,4) var weight_to_break := 4
var weight_current := 0
@export var linked_objects :Array[Node3D] = []
var first_rail :Node3D
var second_rail :Node3D

func _ready():
	first_rail= get_parent().get_node_or_null(str(int(name.split(",")[0])+5)+","+
		name.split(",")[1]+","+
		name.split(",")[2].split("(")[0]+
		"(0)")
	var x:=0
	var y:=0
	if basis.x.is_equal_approx(Vector3.RIGHT):
		x=5
	elif basis.x.is_equal_approx(Vector3.LEFT):
		x=-5
	elif basis.x.is_equal_approx(Vector3.FORWARD):
		y=-5
	else:
		y=5
	second_rail= get_parent().get_node_or_null(str(int(name.split(",")[0])+5)+","+
		str(int(name.split(",")[1])+x)+","+
		str(int(name.split(",")[2].split("(")[0])+y)+
		"(0)")

func _on_area_3d_body_entered(body):
	if body is Minecart:
		weight_current+=body.fill_level
		if weight_current >= weight_to_break:
			destroy()


func _on_area_3d_body_exited(body):
	if body is Minecart:
		weight_current-=body.fill_level

func destroy():
	queue_free()
	if first_rail !=null:
		first_rail.queue_free()
	if second_rail !=null:
		second_rail.queue_free()
	if debris_scene!=null:
		var instance = debris_scene.instantiate()
		instance.position = position
		instance.rotation = rotation
		get_parent().add_child(instance)
		instance.owner = owner
