extends CustomTextureButton
class_name ClearProgress

func _process(_delta): #shortcut to unlock all levels - delete in release
	if (Input.is_action_just_pressed("SHIFT") and Input.is_action_pressed("q_pressed"))\
	 or (Input.is_action_pressed("SHIFT") and Input.is_action_just_pressed("q_pressed")):
		var progress := Progress.new()
		for i in range(0,129):
			progress.level_completion_data[i] = true
		ResourceSaver.save(progress,"user://saves/progress.tres")
		LevelSelectionController.singleton.progress = progress
		LevelSelectionController.singleton.open_page()

func _pressed():
	ResourceSaver.save(Progress.new(),"user://saves/progress.tres")
	LevelSelectionController.singleton.progress = Progress.new()
	LevelSelectionController.singleton.open_page()
