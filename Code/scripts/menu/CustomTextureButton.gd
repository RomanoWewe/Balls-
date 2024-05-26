extends Button
class_name CustomTextureButton

@onready var texture_clicked : NinePatchRect = get_node("NinePatchRect")

var clicked_color = Color(1,1,1,1)
var blank_color = Color(0,0,0,0)

func _ready():
	texture_clicked.self_modulate = blank_color

func _toggled(toggled_on):
	texture_clicked.self_modulate = clicked_color if toggled_on else blank_color

