extends CustomTextureButton
class_name LevelSelectButton

var level : String

func _on_pressed():
	get_parent().get_parent().select_level(self)
