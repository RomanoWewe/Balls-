@tool
extends DefaultButton
class_name ButtonToggle

func activate(index:int):
	super.activate(index)
	connections[index].toggle()

