extends BossState
class_name BossInvertionState

@export var inverse_z:=true
@export var inverse_x:=true
@export var boulder_surface_material:StandardMaterial3D
@export var boulder_default_material:StandardMaterial3D


func enter()->void:
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_surface_material)
	await get_tree().create_timer(1).timeout
	%CurrentLevel.get_node("static/Ball").inverse_z=inverse_z
	%CurrentLevel.get_node("static/Ball").inverse_x=inverse_x
	await get_tree().create_timer(1).timeout
	for i in range(4):
		%Boulders.get_node("Boulder"+str(i)+"/MeshWrapper/MeshInstance3D").set_surface_override_material(0,boulder_default_material)
	exit()
