@tool
extends Activatable
class_name MovingPlatform

@export_group("Default Speeds")
@export var movement_speed := 5.0 : set = set_movement_speed
@export var rotation_speed := 5.0 : set = set_rotation_speed
@export var scaling_speed := 5.0 : set = set_scaling_speed
@export var speed_curve : Curve
var speed_curve_area :float

@export_group("Path setup")
@export var use_relative_transformation :=false
@export var Add_New_Position := false : set = add_new_pos
@export var Load_Next_Position := false : set = load_next_pos
@export var Clear := false : set = clear

@export_group("Debug Info")
@export var draw_path :=true : set = set_draw_path
@export var positions_count := 0
@export var previous_position :=0
@export var next_position :=0
@export var positions : Array[Transform3D] = []
@export var movement_times : Array[float] = []
var is_moving := false
var visualizer : Visualizer 
var time_since_last_step : float = 0.0

var previous_transform :Transform3D

func _ready():
	if !is_inside_tree():
		return
	if !speed_curve:
		speed_curve =Curve.new()
		speed_curve.add_point(Vector2(0,1))
	if Engine.is_editor_hint():
		if visualizer:
			visualizer.queue_free()
		visualizer = Visualizer.new()
		add_sibling.call_deferred(visualizer)
		call_deferred("draw_editor_visuals")
	else:
		if visualizer:
			visualizer.clear_active_meshes()
			visualizer.queue_free()
			visualizer=null
		speed_curve_area = 0.0
		for i in range(0,100):
			speed_curve_area+=speed_curve.sample(float(i)/100)
		speed_curve_area/=100

func _process(delta):
	if (!is_inside_tree()):
		return
	if (!Engine.is_editor_hint()):
		try_moving(delta)

func add_new_pos(_new_value: bool):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	positions.append(transform)
	if (!use_relative_transformation):
		movement_times.append(get_movement_time(positions[positions_count-1],positions[positions_count]))
		movement_times[0]=get_movement_time(positions[positions_count],positions[0])
	else:
		movement_times.append(get_movement_time(Transform3D(),transform))
	positions_count+=1
	next_position =0
	previous_position = positions_count-1
	draw_editor_visuals()

func load_next_pos(_new_value: bool):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	if positions.size()<1:
		print("No Position to load!")
		return
	transform = positions[next_position]
	next_position+=1
	if next_position >=positions.size():
		next_position=0
	previous_position=next_position-1
	if previous_position<0:
		previous_position = positions.size()-1

func clear(_new_value : bool):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	positions_count = 0
	next_position = 0
	positions.clear()
	movement_times.clear()
	draw_editor_visuals()

func set_draw_path(new_value:bool):
	draw_path = new_value
	draw_editor_visuals()

func try_moving(delta:float):
	if (!is_inside_tree() or Engine.is_editor_hint()):
		return
	if (!auto_cycling and steps_left<1):
		return
	if !previous_transform:
		if use_relative_transformation:
			previous_transform = transform
		else:
			previous_transform = positions[previous_position]
	time_since_last_step+=delta
	var t = time_since_last_step/movement_times[next_position]
	var progress :float=0
	var steps =int(t*100)
	for i in range(steps):
		progress+=speed_curve.sample(float(i)/100)
	progress/=100
	progress/=speed_curve_area
	if progress<1:
		if !use_relative_transformation:
			transform = previous_transform.interpolate_with(positions[next_position],progress)
		else:
			transform = previous_transform.interpolate_with(previous_transform*positions[next_position],progress)
	else:
		if use_relative_transformation:
			previous_transform*=positions[next_position]
		else:
			previous_transform=positions[next_position]
		transform = previous_transform
		if (!auto_cycling):
			steps_left-=1
		time_since_last_step = 0
		next_position+=1
		if next_position==positions.size():
			next_position = 0
		previous_position=next_position-1
		if previous_position<0:
			previous_position = positions.size()-1
		while movement_times[next_position]==0:
			if use_relative_transformation:
				previous_transform*=positions[next_position]
			else:
				previous_transform=positions[next_position]
			transform = previous_transform
			if (!auto_cycling):
				steps_left-=1
			time_since_last_step = 0
			next_position+=1
			if next_position==positions.size():
				next_position = 0
			previous_position=next_position-1
			if previous_position<0:
				previous_position = positions.size()-1

func get_movement_time(first_transform : Transform3D, second_transform : Transform3D) ->float:
	if (!first_transform.origin.is_equal_approx( second_transform.origin)):
		return (first_transform.origin - second_transform.origin).length()/movement_speed
	if (!first_transform.basis.get_euler().is_equal_approx( second_transform.basis.get_euler())):
		return (Quaternion(first_transform.basis).angle_to(Quaternion(second_transform.basis)))/rotation_speed
	return (second_transform.basis.get_scale()-first_transform.basis.get_scale()).length()/scaling_speed

func draw_editor_visuals():
	if !(visualizer):
		return
	visualizer.clear_active_meshes()
	if (!draw_path):
		return
	if positions_count<1:
		return
	if use_relative_transformation:
		var prev_transfrom = transform
		var curr_transform = transform
		for i in range(20):
			prev_transfrom = curr_transform
			curr_transform =curr_transform*positions[i%positions_count]
			visualizer.draw_line(curr_transform.origin,prev_transfrom.origin)
			visualizer.draw_point(curr_transform.origin)
	else:
		for i in range(1,positions_count):
			visualizer.draw_line(positions[i-1].origin,positions[i].origin)
			visualizer.draw_point(positions[i].origin)
		visualizer.draw_line(positions[0].origin,positions[positions_count-1].origin)
		visualizer.draw_point(positions[0].origin)

func set_movement_speed(new_value : float):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	movement_speed = new_value
	if movement_speed ==0:
		movement_speed = 0.00000001

func set_rotation_speed(new_value : float):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	rotation_speed = new_value
	if rotation_speed ==0:
		rotation_speed = 0.00000001

func set_scaling_speed(new_value : float):
	if (!is_inside_tree() or !Engine.is_editor_hint()):
		return
	scaling_speed = new_value
	if scaling_speed ==0:
		scaling_speed = 0.00000001

func _exit_tree():
	if visualizer and is_instance_valid(visualizer):
		visualizer.clear_active_meshes()
		visualizer.queue_free()

func scale_movement_times(value:float):
	movement_times = movement_times.duplicate()
	for i in range(0,movement_times.size()):
		movement_times[i]=value*movement_times[i]
