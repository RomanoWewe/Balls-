extends Node
class_name SkinsMenu

@export var skin_data :SkinData
@export var stats : Stats
@export var settings : Settings
var current_skin :=0
@export var achievement_animator : AnimationPlayer
@export var is_menu :=false
static var singleton : SkinsMenu

@export var icon_locked : Texture2D
@export var locked_background_color : Color
@export var background_colors : Array[Color]

func _ready():
	if skin_data == null:
		if   FileAccess.file_exists("res://skindata.tres"):
			skin_data = load("res://skindata.tres")
		else:
			skin_data = SkinData.new()
	if stats == null:
		if   FileAccess.file_exists("user://stats.tres"):
			stats = load("user://stats.tres")
		if stats ==null or stats.unlocked_skins.size()!=skin_data.scenes.size():
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
	if stats.unlocked_skins[current_skin]:
		$Name.text = "[center]"+skin_data.names[current_skin]
	else:
		$Name.text = "Locked"
	$Description.text = skin_data.descriptions[current_skin]
	$SkinCounter.text = "[center]"+str(stats.unlocked_skins_count)+"/"+str(stats.unlocked_skins.size())
	$Select.disabled = !stats.unlocked_skins[current_skin]
	
	if current_skin !=0:
		if stats.unlocked_skins[current_skin-1]:
			$Skin1/Icon/Texture.texture = skin_data.icons[current_skin-1]
			$Skin1/Background.self_modulate = background_colors[skin_data.rarities[current_skin-1]]
			$Skin1/index.text = str(current_skin-1)
		else:
			$Skin1/Icon/Texture.texture = icon_locked
			$Skin1/Background.self_modulate = locked_background_color
			$Skin1/index.text = str(current_skin-1)
		$Skin1/Selected.visible=settings.selected_skin==current_skin-1
	else:
		if stats.unlocked_skins[current_skin-1]:
			$Skin1/Icon/Texture.texture = skin_data.icons[skin_data.icons.size()-1]
			$Skin1/Background.self_modulate = background_colors[skin_data.rarities[skin_data.icons.size()-1]]
			$Skin1/index.text = str(skin_data.icons.size()-1)
		else:
			$Skin1/Icon/Texture.texture = icon_locked
			$Skin1/Background.self_modulate = locked_background_color
			$Skin1/index.text = str(skin_data.icons.size()-1)
		$Skin1/Selected.visible=settings.selected_skin==skin_data.icons.size()-1
	if stats.unlocked_skins[current_skin]:
		$Skin2/Icon/Texture.texture = skin_data.icons[current_skin]
		$Skin2/Background.self_modulate = background_colors[skin_data.rarities[current_skin]]
		$Skin2/index.text = str(current_skin)
	else:
		$Skin2/Icon/Texture.texture = icon_locked
		$Skin2/Background.self_modulate = locked_background_color
		$Skin2/index.text = str(current_skin)
	$Skin2/Selected.visible=settings.selected_skin==current_skin
	if current_skin !=skin_data.icons.size()-1:
		if stats.unlocked_skins[current_skin+1]:
			$Skin3/Icon/Texture.texture = skin_data.icons[current_skin+1]
			$Skin3/Background.self_modulate = background_colors[skin_data.rarities[current_skin+1]]
			$Skin3/index.text = str(current_skin+1)
		else:
			$Skin3/Icon/Texture.texture = icon_locked
			$Skin3/Background.self_modulate = locked_background_color
			$Skin3/index.text = str(current_skin+1)
		$Skin3/Selected.visible=settings.selected_skin==current_skin+1
	else:
		if stats.unlocked_skins[0]:
			$Skin3/Icon/Texture.texture = skin_data.icons[0]
			$Skin3/Background.self_modulate = background_colors[skin_data.rarities[0]]
		else:
			$Skin3/Icon/Texture.texture = icon_locked
			$Skin3/Background.self_modulate = locked_background_color
		$Skin3/index.text = "0"
		$Skin3/Selected.visible=settings.selected_skin==0

func _on_select_pressed():
	if settings.selected_skin !=current_skin:
		settings.selected_skin= current_skin
		stats.skins_changed +=1
		refresh()

func _on_next_skin_pressed():
	current_skin = current_skin+1
	if current_skin>skin_data.names.size()-1:
		current_skin=0
	
	refresh()

func _on_prev_skin_pressed():
	current_skin = current_skin-1
	if current_skin<0:
		current_skin=skin_data.names.size()-1
	refresh()

func unlock_skin(i):
	stats.unlocked_skins[i]=true
	stats.unlocked_skins_count+=1
	if i==0:
		return
	achievement_animator.current_animation = "Up"
	await  get_tree().create_timer(2).timeout
	achievement_animator.current_animation = "Down"


func _on_secret_pressed():
	stats.secrets_unlocked+=1
	$Secret.disabled=true
	refresh()
