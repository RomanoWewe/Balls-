extends Activatable
class_name Relay

@export var activatables: Array[Activatable]

func toggle():
	for activatable in activatables:
		if activatable != null:
			activatable.toggle()

func add_to_stack():
	activated_stack+=1
func remove_from_stack():
	activated_stack-=1 
	
func set_active(value: bool):
	for activatable in activatables:
		if activatable != null:
			activatable.set_active (value)

func add_steps(steps : int):
	for activatable in activatables:
		if activatable != null:
			activatable.add_steps(steps)


func set_auto_cycling(new_value:bool):
	for activatable in activatables:
		if activatable != null:
			activatable.set_auto_cycling(new_value)
	
func set_step(step : int):
	for activatable in activatables:
		if activatable != null:
			activatable.set_step( step)
