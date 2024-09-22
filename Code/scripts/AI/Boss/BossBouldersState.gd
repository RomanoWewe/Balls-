extends BossState
class_name BossBouldersState


@export_range(1,4) var active_boulder_count=1
@export var boulder_activation_offset:=2
@export var base_speed:=1.0
@export_subgroup("Boulders")
@export var boulder_enter_animation_duration:float
@export var boulder_exit_animation_duration:float
@export var boulder_base_positions :Array[Marker3D]


func enter()->void:
	is_ready=true
	for i in range(active_boulder_count):
		%Boulders.get_node("Boulder"+str(i)+"/AnimationPlayer").current_animation="enter"
		%Boulders.get_node("Boulder"+str(i)).base_speed=base_speed
		await get_tree().create_timer(boulder_activation_offset).timeout

func exit()->void:
	is_ready=false
	for boulder in %Boulders.get_children():
		if boulder.is_running:
			boulder.return_to_base()
	await get_tree().create_timer(2).timeout
	transfer_state.emit()

func on_rune_used()->void:
	push_error("Player not supposed to have a rune during this stage!")
