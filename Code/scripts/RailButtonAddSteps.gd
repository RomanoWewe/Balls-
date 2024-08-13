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

func add_connection(activatable : Activatable):
	if (!is_inside_tree()):
		return
	connections.append(activatable)

func clear_connections(_new_val:bool):
	connections =[]

func activate(index:int):
	connections[index].add_steps(1)

func remove_nulls():
	var start_size := connections.size()
	var i :=0
	while i<start_size:
		if connections[i] == null:
			connections.remove_at(i)
			start_size-=1
		else:
			i+=1
