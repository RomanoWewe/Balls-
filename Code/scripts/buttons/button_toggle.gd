@tool
extends DefaultButton
class_name ButtonToggle

func _on_body_exited(body):
	pass

func activate(index:int):
	super.activate(index)
	if connections[index].activated_stack == 0:
		connections[index].add_steps(1)
	connections[index].add_to_stack()

func deactivate(index:int):
	super.deactivate(index)
	if connections[index].activated_stack == 1:
		connections[index].add_steps(1)
	connections[index].remove_from_stack()

func _on_body_entered(body):
	if not body is GravitationalObject:
		return
	is_active = !is_active
	if $ButtonOffSound.is_inside_tree() and is_active:
		$ButtonOffSound.playing=false
	if $ButtonOnSound.is_inside_tree() and is_active:
		$ButtonOnSound.playing=true
	if $ButtonOffSound.is_inside_tree() and !is_active:
		$ButtonOffSound.playing=true
	if $ButtonOnSound.is_inside_tree() and !is_active:
		$ButtonOnSound.playing=false
	if is_active:
		for i in range(connections.size()):
			activate(i)
	else:
		for i in range(connections.size()):
			deactivate(i)
		
