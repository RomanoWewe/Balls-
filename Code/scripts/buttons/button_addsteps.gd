@tool
extends DefaultButton
class_name ButtonAddSteps

@export var steps : int ##Steps - количество шагов, которые будут прибавлены с объектам при Activation Type ==ADD_STEPS

func activate(index:int):
	connections[index].call_deferred("add_steps",steps)
