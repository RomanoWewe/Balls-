@tool
extends EditorPlugin
class_name LevelEditor


var dock : Control
var editor: EditorInterface
static var preview: EditorResourcePreview


func _enter_tree():
	editor = get_editor_interface()
	preview = editor.get_resource_previewer()
	
	dock = preload("res://addons/leveleditor/EditorInterface.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR , dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

func _input(event):
	if is_mouse_over_main_screen() and event is InputEventMouseButton and\
		(event.button_index == 1) and dock.active:
		get_viewport().set_input_as_handled()

static func get_preview(scene: String, receiver: Object, function: StringName, index : int) -> void:
	preview.queue_resource_preview(scene, receiver, function, index)

static func is_mouse_over_main_screen():
	return EditorInterface.get_editor_main_screen().get_global_rect().has_point(
		EditorInterface.get_editor_main_screen().get_global_mouse_position())
