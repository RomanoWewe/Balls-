@tool
extends Node
class_name BossState

@export var duration:= 0.0

var time_since_start:=0.0
var is_ready:=false

signal transfer_state

func enter()->void:
	is_ready=true

func update(delta:float)->void:
	if !is_ready:
		return
	time_since_start+=delta
	if time_since_start>=duration and duration>0:
		exit()

func exit()->void:
	is_ready=false
	transfer_state.emit()

func on_rune_used()->void:
	push_error("Not Implemented!")


func fade_in(instance:Node3D):
	if instance is Camera3D:
		var t=0.0
		while t<1:
			instance.attributes.exposure_multiplier=t
			await get_tree().create_timer(0.02).timeout
			t+=.01
	else:
		instance.process_mode=Node.PROCESS_MODE_DISABLED
		var t=0.0
		while t<1:
			for child in instance.get_children(true):
				if child is MeshInstance3D:
					child.transparency=1-t
			await get_tree().create_timer(0.02).timeout
			t+=.01
		instance.process_mode=Node.PROCESS_MODE_INHERIT

func fade_out(instance:Node3D):
	if instance is Camera3D:
		var t=0.0
		while t<1:
			instance.attributes.exposure_multiplier=1-t
			await get_tree().create_timer(0.02).timeout
			t+=.01
	else:
		instance.process_mode=Node.PROCESS_MODE_DISABLED
		var t=0.0
		while t<1:
			for child in instance.get_children(true):
				if child is MeshInstance3D:
					child.transparency=t
				elif child is Light3D:
					print(child.name)
					child.light_energy=1-t
			await get_tree().create_timer(0.02).timeout
			t+=.01
		instance.queue_free()
