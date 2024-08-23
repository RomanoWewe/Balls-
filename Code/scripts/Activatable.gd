@tool
extends AnimatableBody3D
class_name  Activatable

@export var auto_cycling : bool = false :set = set_auto_cycling
@export var steps_left : int = 0
@export var Bind_Activator : DefaultButton : set = bind_activator
var activated_stack: int =0;

func toggle():
	auto_cycling = !auto_cycling

func add_to_stack():
	activated_stack+=1
func remove_from_stack():
	activated_stack-=1 
	
func set_active(value: bool):
	auto_cycling = value

func add_steps(steps : int):
	steps_left +=steps

func bind_activator(new_value: DefaultButton):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	if (!"Connections" in new_value):
		push_error("Unable to bind, list of connections not found")
		return
	new_value.Connections.append(self)

func set_auto_cycling(new_value:bool):
	auto_cycling = new_value
	
func set_step(step : int):
	steps_left = step
