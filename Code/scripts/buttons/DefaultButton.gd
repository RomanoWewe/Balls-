@tool
extends Area3D
class_name DefaultButton

@export var Add_Connection : Activatable : set = add_connection ## Add Connection - выбрать и добавить новый объект к списку активируемых
@export var Clear_Connections : bool : set = clear_connections ## Clear Connection - очистить все списки активируемых обьектов
@export var connections : Array[Activatable] = [] ## Сonnections - список активируеммых обьектов
@export var delay := 0.0 ##задержка в секундах перед выключением
@export var text_timer : Label3D 
var times_activated :=0
var is_active :=false

func _ready():
	remove_nulls()
	var press_animation = get_node_or_null("MovingPlatform")
	while connections.has(press_animation):
		connections.erase(press_animation)
	if Engine.is_editor_hint():
		return
	if press_animation:
		connections.append(press_animation)

func add_connection(activatable : Activatable):
	if (!is_inside_tree()):
		return
	connections.append(activatable)

func clear_connections(_new_val:bool):
	connections =[]

func _on_body_entered(body):
	if not body is GravitationalObject:
		return
	times_activated +=1
	if times_activated>1:
		return
	if $ButtonOffSound.is_inside_tree():
		$ButtonOffSound.playing=false
	if $ButtonOnSound.is_inside_tree():
		$ButtonOnSound.playing=true
	for i in range(connections.size()):
		activate(i)


func _on_body_exited(body):
	if not body is GravitationalObject:
		return
	times_activated-=1
	if times_activated>0:
		return
	is_active = true
	var waiting_time = delay
	var prev_number = floor(waiting_time)
	while waiting_time>0:
		if times_activated>0:
			return
		if (prev_number != floor(waiting_time)):
			prev_number = floor(waiting_time)
			popup(str(floor(waiting_time)+1))
		await get_tree().create_timer(0.016,false).timeout
		waiting_time-=0.016
	is_active = false
	if $ButtonOffSound.is_inside_tree():
		$ButtonOffSound.playing=true
	if $ButtonOnSound.is_inside_tree():
		$ButtonOnSound.playing=false
	for i in range(connections.size()):
		deactivate(i)

func popup(text: String):
	var new = text_timer.duplicate()
	add_child(new)
	new.text = text
	var t = 0
	var oldpos = new.position 
	while t<0.75:
		await get_tree().create_timer(0.016).timeout
		t+=0.016
		new.position = oldpos.lerp(oldpos+Vector3(0,3,0),sin(t*4/3*PI/2))
		new.scale = Vector3(0,0,0).lerp(Vector3(1,1,1),t)+Vector3(0.4,0.4,0.4)
		new.modulate.a =cos(t*4/6*PI)
		new.outline_modulate.a =cos(t*4/6*PI)
	new.queue_free()

func activate(_index:int):
	pass

func deactivate(_index:int):
	pass

func remove_nulls():
	var start_size := connections.size()
	var i :=0
	while i<start_size:
		if connections[i] == null:
			connections.remove_at(i)
			start_size-=1
		else:
			i+=1
