extends Button
class_name CustomTextureButton

@onready var texture_clicked : NinePatchRect = get_node("NinePatchRect")

var clicked_color = Color(1,1,1,1)
var blank_color = Color(0,0,0,0)

func _ready():
	texture_clicked.self_modulate = blank_color
	if toggle_mode:
		return
	if !button_down.is_connected(on_button_down):
		button_down.connect(on_button_down)
	if !button_up.is_connected(on_button_up):
		button_up.connect(on_button_up)

func _toggled(toggled_on):
	texture_clicked.self_modulate = clicked_color if toggled_on else blank_color

func on_button_down():
	texture_clicked.self_modulate = clicked_color

func on_button_up():
	texture_clicked.self_modulate = blank_color
