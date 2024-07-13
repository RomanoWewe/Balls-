extends Area3D
class_name AreaTracker

var objects_in_area: Array[Node3D] = []
@export var tracked_groups : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_area3d_body_entered)
	body_exited.connect(_on_area3d_body_exited)


func _on_area3d_body_entered(body):
	if intersect(body.get_groups(),tracked_groups).size() > 0:
		objects_in_area.append(body)

func _on_area3d_body_exited(body):
	if objects_in_area.has(body):
		objects_in_area.erase(body)

func intersect(array1, array2) -> Array:
	var intersection = []
	for item in array1:
		if array2.has(item):
			intersection.append(item)
	return intersection
