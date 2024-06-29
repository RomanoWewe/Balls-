extends Control
class_name PauseMenu

enum state{
	UNPAUSED,
	PAUSED,
	SETTINGS
}

@export var button_group : ButtonGroup
@export var resume_button : Button
@export var return_button : Button
var current_state = state.UNPAUSED
@onready var restart_button = $Restart
@onready var animator : AnimationPlayer= get_parent().get_node("AnimationPlayer")


func _process(_delta):
	if (Input.is_action_just_pressed("Esc_pressed")):
		if current_state == state.UNPAUSED:
			pause()
			resume_button.toggle_mode= false
			return
		if current_state == state.PAUSED:
			unpause()
			resume_button.toggle_mode= true
			return
		if current_state == state.SETTINGS:
			back_to_pause_menu()
			return_button.toggle_mode=true
			return_button.toggled.emit()
			return
	if Input.is_action_just_pressed("r_pressed"):
		restart_button.on_pressed()

func pause():
	if get_parent().get_parent().level_finished:
		return
	current_state = state.PAUSED
	get_tree().paused = true
	animator.play("game-paused")

func unpause():
	if get_parent().get_parent().level_finished:
		return
	current_state = state.UNPAUSED
	get_tree().paused = false
	animator.play("paused-game")

func back_to_pause_menu():
	if get_parent().get_parent().level_finished:
		return
	current_state = state.PAUSED
	get_tree().paused = true
	animator.play("settings-paused")

func settings():
	if get_parent().get_parent().level_finished:
		return
	current_state = state.SETTINGS
	get_tree().paused = true
	animator.play("paused-settings")
