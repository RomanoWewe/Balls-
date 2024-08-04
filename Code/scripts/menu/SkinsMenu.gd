extends Node
class_name SkinsMenu

@export var skin_data :SkinData
@export var stats : Stats
@export var settings : Settings
var current_skin :=0
@export var is_menu :=false
static var singleton : SkinsMenu


func _ready():
	if skin_data == null:
		if   FileAccess.file_exists("res://skindata.tres"):
			skin_data = load("res://skindata.tres")
		else:
			skin_data = SkinData.new()
	if stats == null:
		if   FileAccess.file_exists("user://stats.tres"):
			stats = load("user://stats.tres")
		else:
			stats = Stats.new()
	if settings == null:
		if   FileAccess.file_exists("user://settings.tres"):
			settings = load("user://settings.tres")
		else:
			settings = Settings.new()
	current_skin = settings.selected_skin
	refresh()
	singleton = self


func refresh():
	for i in range(skin_data.requirement_types.size()):
		if stats.unlocked_skins[i]:
			continue
		if stats.get(skin_data.requirement_types[i])>=skin_data.requirement_values[i]:
			unlock_skin(i)
	ResourceSaver.save(stats,"user://stats.tres")
	
	if !is_menu:
		return
	$Name.text = skin_data.names[current_skin]
	$Description.text = skin_data.descriptions[current_skin]
	$SkinCounter.text = str(stats.unlocked_skins_count)+"/"+str(stats.unlocked_skins.size())
	$Select.disabled = !stats.unlocked_skins[current_skin]

func _on_select_pressed():
	if settings.selected_skin !=current_skin:
		settings.selected_skin= current_skin
		stats.skins_changed +=1
		refresh()

func _on_next_skin_pressed():
	current_skin = (current_skin+1) % skin_data.names.size()
	refresh()

func _on_prev_skin_pressed():
	current_skin = (current_skin-1) % skin_data.names.size()
	refresh()

func unlock_skin(i):
	stats.unlocked_skins[i]=true
	stats.unlocked_skins_count+=1
	print("Unlocked Skin!")
	print(skin_data.names[i])
