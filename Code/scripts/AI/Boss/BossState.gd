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
