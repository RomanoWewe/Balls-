extends Activatable
class_name ActivatableLight

func _ready():
	$SpotLight3D.visible=auto_cycling

func add_steps(steps : int):
	auto_cycling = !auto_cycling
	$SpotLight3D.visible= auto_cycling
