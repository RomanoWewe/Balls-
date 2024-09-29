@tool
extends Node3D
class_name BossStateMachine

var current_state : BossState
var current_state_id := 0

@onready var level = get_tree().get_root().get_child(0) as Level
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	set_state(current_state_id)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if current_state!=null:
		current_state.update(delta)

func transfer_state():
	if current_state!=null:
		current_state.transfer_state.disconnect(transfer_state)
	set_state(current_state_id+1)

func set_state(state_id:int):
	if get_children().size()<=state_id:
		current_state=null
		current_state_id=-1
		return
	current_state = get_child(state_id)
	current_state_id=state_id
	current_state.enter()
	current_state.transfer_state.connect(transfer_state)

func _on_boss_rune_collect_area_body_entered(body: Node3D) -> void:
	if !body is Ball:
		return
	if level.runes_collected.size()>0:
		level.rune_used(level.runes_collected[0])
		%RuneUseAnimator/RuneUseSound.play()
		current_state.on_rune_used()
