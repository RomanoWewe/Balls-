extends Control
class_name MainMenuAnimator

var FRAMETIME := 0.01666666666
var SCREEN_HEIGHT := 640.0

@export var main_screen : Control
@export var settings_screen : Control
@export var empty_screen : Control
@export var levels_screen : Control
@export var achievements_screen : Control
@export var animation_time := 0.5
 
var is_animation_playing := false

func _ready():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t = 0.0
	while t<=animation_time:
		empty_screen.position = Vector2(0,
			-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-t/animation_time*PI/2)+SCREEN_HEIGHT)
		empty_screen.scale = Vector2(1,cos(t/animation_time*PI/2))
		main_screen.position = Vector2(0,
			-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(t/animation_time)*(PI/2))+SCREEN_HEIGHT)
		main_screen.scale = Vector2(1,sin(t/animation_time*PI/2))
		await get_tree().create_timer(FRAMETIME).timeout
		t+=FRAMETIME
	is_animation_playing = false

func main_achievements():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t = 0.0
	while t<=animation_time:
		main_screen.position = Vector2(-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-t/animation_time*PI/2)+640,
			0)
		main_screen.scale = Vector2(cos(t/animation_time*PI/2),1)
		achievements_screen.position = Vector2(-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(t/animation_time)*(PI/2))+640,
			0)
		achievements_screen.scale = Vector2(sin(t/animation_time*PI/2),1)
		await get_tree().create_timer(FRAMETIME).timeout
		t+=FRAMETIME
	is_animation_playing = false

func achievements_main():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t =animation_time
	while t>0:
		main_screen.position = Vector2(-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-abs(t)/animation_time*PI/2)+640,
			0)
		main_screen.scale = Vector2(cos(abs(t)/animation_time*PI/2),1)
		achievements_screen.position = Vector2(-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(abs(t)/animation_time)*(PI/2))+640,
			0)
		achievements_screen.scale = Vector2(sin(abs(t)/animation_time*PI/2),1)
		await get_tree().create_timer(FRAMETIME).timeout
		t-=FRAMETIME
	is_animation_playing = false

func main_levels():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t =animation_time
	while t>0:
		levels_screen.position = Vector2(-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-abs(t)/animation_time*PI/2)+640,
			0)
		levels_screen.scale = Vector2(cos(abs(t)/animation_time*PI/2),1)
		main_screen.position = Vector2(-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(abs(t)/animation_time)*(PI/2))+640,
			0)
		main_screen.scale = Vector2(sin(abs(t)/animation_time*PI/2),1)
		await get_tree().create_timer(FRAMETIME).timeout
		t-=FRAMETIME
	is_animation_playing = false

func levels_main():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t = 0.0
	while t<=animation_time:
		levels_screen.position = Vector2(-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-t/animation_time*PI/2)+640,
			0)
		levels_screen.scale = Vector2(cos(t/animation_time*PI/2),1)
		main_screen.position = Vector2(-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(t/animation_time)*(PI/2))+640,
			0)
		main_screen.scale = Vector2(sin(t/animation_time*PI/2),1)
		await get_tree().create_timer(FRAMETIME).timeout
		t+=FRAMETIME
	is_animation_playing = false


func main_settings():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t = 0.0
	while t<=animation_time:
		main_screen.position = Vector2(0,
			-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-t/animation_time*PI/2)+SCREEN_HEIGHT)
		main_screen.scale = Vector2(1,cos(t/animation_time*PI/2))
		settings_screen.position = Vector2(0,
			-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(t/animation_time)*(PI/2))+SCREEN_HEIGHT)
		settings_screen.scale = Vector2(1,sin(t/animation_time*PI/2))
		await get_tree().create_timer(FRAMETIME).timeout
		t+=FRAMETIME
	is_animation_playing = false


func settings_main():
	if is_animation_playing:
		return
	is_animation_playing = true
	var t =animation_time
	while t>=0:
		main_screen.position = Vector2(0,
			-SCREEN_HEIGHT*sqrt(2)*sin(PI/4-t/animation_time*PI/2)+SCREEN_HEIGHT)
		main_screen.scale = Vector2(1,cos(t/animation_time*PI/2))
		settings_screen.position = Vector2(0,
			-SCREEN_HEIGHT * sqrt(2)*cos(PI/4-(t/animation_time)*(PI/2))+SCREEN_HEIGHT)
		settings_screen.scale = Vector2(1,sin(t/animation_time*PI/2))
		await get_tree().create_timer(FRAMETIME).timeout
		t-=FRAMETIME
	is_animation_playing = false
