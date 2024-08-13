@tool extends Rail
class_name RailButtonToggle

@export var Add_Connection : Activatable : set = add_connection ## Add Connection - выбрать и добавить новый объект к списку активируемых
@export var Clear_Connections : bool : set = clear_connections ## Clear Connection - очистить все списки активируемых обьектов
@export var connections : Array[Activatable] = [] ## Сonnections - список активируеммых обьектов
@export var weight_to_activate :=0
@export var is_active :=false

func _ready():
	remove_nulls()

func _on_area_3d_area_entered(area):
	var area_parent = area.get_parent()
	if not area_parent is Minecart:
		return
	if area_parent.fill_level>=weight_to_activate:
		is_active = true
		if $ButtonOffSound.is_inside_tree():
			$ButtonOffSound.playing=true
		for i in range(connections.size()):
			activate(i)

func _on_area_3d_area_exited(area):
	var area_parent = area.get_parent()
	if not area_parent is Minecart:
		return
	if is_active:
		is_active = false
		if $ButtonOnSound.is_inside_tree():
			$ButtonOnSound.playing=false
		for i in range(connections.size()):
			deactivate(i)


func add_connection(activatable : Activatable):
	if (!is_inside_tree()):
		return
	connections.append(activatable)

func clear_connections(_new_val:bool):
	connections =[]

func activate(index:int):
	if connections[index].activated_stack == 0:
		connections[index].add_steps(1)
	connections[index].add_to_stack()

func deactivate(index:int):
	if connections[index].activated_stack == 1:
		connections[index].add_steps(1)
	connections[index].remove_from_stack()

func remove_nulls():
	var start_size := connections.size()
	var i :=0
	while i<start_size:
		if connections[i] == null:
			connections.remove_at(i)
			start_size-=1
		else:
			i+=1
