@tool
extends Control
class_name LevelEditorInterface

enum Tool {
	Edit,
	Rotate
}

var selected_object : PackedScene
var selected_tool : Tool
var prev_mouse_tile :Vector2i
var static_node :Node
var z_pressed_last_frame :=false
var c_pressed_last_frame :=false
var space_pressed_last_frame :=false

var active := false
var current_filter : String = ""
var filter_by_folder := false
var y_layer :=5.0
var layer :=0

var item_list : ItemList
var tool_selection : OptionButton
var text_edit : TextEdit

func _enter_tree():
	item_list = $VBoxContainer/ItemList
	tool_selection = $VBoxContainer/HBoxContainer/OptionButton
	text_edit = $VBoxContainer/HBoxContainer2/TextEdit
	
	tool_selection.clear()
	for tool in Tool.keys():
		tool_selection.add_item(tool)
	
	if !InputMap.has_action("LMB"):
		InputMap.add_action("LMB")
	if !InputMap.has_action("RMB"):
		InputMap.add_action("RMB")
	if !InputMap.has_action("SHIFT"):
		InputMap.add_action("SHIFT")
	var ev1 = InputEventMouseButton.new()
	ev1.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("LMB", ev1)
	var ev2 = InputEventMouseButton.new()
	ev2.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("RMB", ev2)
	var ev3 = InputEventKey.new()
	ev3.keycode = KEY_SHIFT
	InputMap.action_add_event("SHIFT", ev3)
	
	refresh_object_list()

func _process(delta):
	if !get_tree().get_edited_scene_root() is Level:
		return
	if !active or !LevelEditor.is_mouse_over_main_screen():
		return
	if static_node!=get_tree().get_edited_scene_root().find_child("static"):
		set_static_node()
	
	var origin = get_mouse_plane_pos().snapped(Vector3(5,5,5))
	var result = static_node.find_child(str(y_layer)+","+str(origin.x)+","+str(origin.z)+"("+str(layer)+")")
	
	if selected_tool == Tool.Edit:
		if !result and Input.is_action_pressed("LMB") and selected_object and !Input.is_action_pressed("SHIFT"):
			call_deferred("spawn",origin)
		if result and Input.is_action_pressed("LMB") and Input.is_action_pressed("SHIFT"):
			result.queue_free()
	
	if selected_tool == Tool.Rotate:
		if result and Input.is_action_just_pressed("LMB"):
			if Input.is_action_pressed("SHIFT"):
				result.transform.basis = Basis(Vector3.UP, PI/2) * result.transform.basis
			else:
				result.transform.basis = Basis(Vector3.UP, -PI/2) * result.transform.basis

func get_scenes_in_folder(path:StringName):
	var dir :=DirAccess.open(path)
	var filePaths := []
	for file in dir.get_files():
		if (current_filter== "" or \
		(filter_by_folder and path.to_lower().contains(current_filter.to_lower()))\
		or (!filter_by_folder and file.to_lower().contains(current_filter.to_lower()))\
		)and !path.contains("_"):
			filePaths.append(file.get_basename())
	for directory in dir.get_directories():
		filePaths.append_array(get_scenes_in_folder(path+"/"+directory))
	return filePaths

func set_static_node():
	static_node = get_tree().get_edited_scene_root().find_child("static")
	if !static_node:
		static_node = Node3D.new()
		get_tree().get_edited_scene_root().add_child(static_node)
		static_node.set_owner(get_tree().get_edited_scene_root())
		static_node.name = "static"

func spawn(origin:Vector3):
	var instance = selected_object.instantiate()
	static_node.add_child(instance)
	instance.set_owner(get_tree().get_edited_scene_root())
	instance.name = str(y_layer)+","+str(origin.x)+","+str(origin.z)+"("+str(layer)+")"
	instance.transform.origin = Vector3(origin.x,y_layer,origin.z)

func get_mouse_plane_pos():
	var cam = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	var mousepos = EditorInterface.get_editor_viewport_3d(0).get_mouse_position()

	return cam.project_ray_origin(mousepos)

func refresh_object_list():
	item_list.clear()
	var object_scenes_names = get_scenes_in_folder("res://Scenes/Objects")
	for object in object_scenes_names:
		item_list.add_item(object)

func _on_check_button_toggled(toggled_on):
	active = toggled_on

func _on_item_list_item_selected(index):
	selected_object = load(get_full_file_path(item_list.get_item_text(index)))

func get_full_file_path(name: StringName, previous_path = "res://Scenes/Objects"):
	var dir :=DirAccess.open(previous_path)
	if (dir.get_files().has(name+".tscn")):
		return previous_path +"/"+ name+".tscn"
	for directory in dir.get_directories():
		var full_path = get_full_file_path(name,previous_path+"/"+directory)
		if full_path:
			return full_path

func set_item_icon( path : String,  preview : Texture2D,  thumbnail_preview : Texture2D,item_index : int):
	item_list.set_item_icon(item_index,preview)

func _on_filter_option_toggled(toggled_on):
	filter_by_folder = toggled_on
	refresh_object_list()

func _on_text_edit_text_changed():
	current_filter = text_edit.text
	refresh_object_list()

func _on_option_button_item_selected(index):
	selected_tool = index

func _on_spin_box_value_changed(value):
	y_layer = value

func _on_layers_value_changed(value):
	layer = value
