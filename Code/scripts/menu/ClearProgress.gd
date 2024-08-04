extends CustomTextureButton
class_name ClearProgress

@export var sure_screen :Control

func _process(_delta): #shortcut to unlock all levels - delete in release
	if (Input.is_action_just_pressed("SHIFT") and Input.is_action_pressed("q_pressed"))\
	 or (Input.is_action_pressed("SHIFT") and Input.is_action_just_pressed("q_pressed")):
		var stats := Stats.new()
		stats.levels_completed=128
		for i in stats.unlocked_skins.size():
			stats.unlocked_skins[i] = true
		ResourceSaver.save(stats,"user://stats.tres")
		LevelSelectionController.singleton.stats = stats
		LevelSelectionController.singleton.open_page()
		SkinsMenu.singleton.stats = stats
		SkinsMenu.singleton.refresh()

func _toggled(toggled_on):
	if sure_screen.visible:
		return
	sure_screen.visible=true
	texture_clicked.self_modulate = clicked_color if toggled_on else blank_color

func _on_sure_no_pressed():
	button_pressed=false
	sure_screen.visible=false
	texture_clicked.self_modulate = clicked_color if button_pressed else blank_color

func _on_sure_yes_pressed():
	button_pressed=false
	sure_screen.visible=false
	texture_clicked.self_modulate = clicked_color if button_pressed else blank_color
	ResourceSaver.save(Stats.new(),"user://stats.tres")
	LevelSelectionController.singleton.stats = Stats.new()
	LevelSelectionController.singleton.open_page()
	SkinsMenu.singleton.stats = LevelSelectionController.singleton.stats
	SkinsMenu.singleton.settings.selected_skin = 0
	SkinsMenu.singleton.current_skin = 0
	SkinsMenu.singleton.refresh()
	
	
