@tool
extends DefaultButton
class_name ButtonHold

@export var inversed : bool = false

func activate(index:int):
	super.activate(index)
	connections[index].set_active(!inversed)

func deactivate(index:int):
	super.deactivate(index)
	connections[index].set_active(inversed)
