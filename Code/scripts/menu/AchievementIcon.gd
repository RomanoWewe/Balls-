extends TextureRect
class_name AchievementIcon

@export_enum("deaths_by_cannon","deaths_by_spikes","deaths_by_fall","coins_collected",
	"levels_completed","levels_completed_in_time","skins_unlocked","skins_changed",
	"teleports_used","all_levels_complete_and_all_skins_unlocked",
	"all_other_achievements_unlocked")
var stat_to_track : String = ""
@export var value_required : float

func _ready():
	if stat_to_track =="":
		queue_free()
