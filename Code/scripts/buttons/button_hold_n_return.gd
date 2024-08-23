@tool
extends DefaultButton
class_name ButtonHoldNReturn

func activate(index:int):
	super.activate(index)
	if connections[index].activated_stack == 0:
		connections[index].call_deferred("add_steps",1)
	connections[index].add_to_stack()

func deactivate(index:int):
	super.deactivate(index)
	if connections[index].activated_stack == 1:
		connections[index].call_deferred("add_steps",1)
	connections[index].remove_from_stack()
