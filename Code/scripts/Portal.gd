@tool
extends Activatable
class_name Portal

var OFF_COLOR = Color(0.2,0.2,0.2,1)
var ON_COLOR = Color(1,1,1,1)
var since_last_step_subtract := 0.0
var cooldown :=false
@export var exit_portal : Portal : set = set_exit_portal
@export var retain_speed := false
var visualizer : Visualizer 

func set_exit_portal(new_val:Portal):
	exit_portal = new_val
	if visualizer ==null:
		return
	visualizer.clear_active_meshes()
	if new_val ==null:
		return
	visualizer.draw_line($area.global_position,exit_portal.get_node("area").global_position)
	visualizer.draw_point(exit_portal.get_node("area").global_position)

func toggle():
	auto_cycling = !auto_cycling
	if auto_cycling:
		$mesh.material_override.albedo_color=ON_COLOR
	else:
		$mesh.material_override.albedo_color=OFF_COLOR

func _ready():
	if !is_inside_tree():
		return
	$mesh.material_override = $mesh.material_override.duplicate()
	if auto_cycling:
		$mesh.material_override.albedo_color=ON_COLOR
	else:
		$mesh.material_override.albedo_color=OFF_COLOR
	if Engine.is_editor_hint():
		if(visualizer != null):
			visualizer.queue_free()
		visualizer = Visualizer.new()
		add_sibling.call_deferred(visualizer)
		visualizer.add_to_group("DontSave")
	

func _process(delta) :
	if !is_inside_tree() :
		return
	if Engine.is_editor_hint():
		if exit_portal:
			if visualizer ==null or is_instance_valid(visualizer):
				return
			visualizer.clear_active_meshes()
			visualizer.draw_line($area.global_position,exit_portal.get_node("area").global_position)
			visualizer.draw_point(exit_portal.get_node("area").global_position)
		return
	if(auto_cycling or steps_left<1):
		return
	since_last_step_subtract+=delta
	if since_last_step_subtract>=1.0:
		since_last_step_subtract=0
		steps_left-=1

func set_auto_cycling(new_value:bool):
	auto_cycling = new_value
	if auto_cycling:
		$mesh.material_override.albedo_color=ON_COLOR
	else:
		$mesh.material_override.albedo_color=OFF_COLOR

func _on_area_body_entered(body):
	if !is_inside_tree() or Engine.is_editor_hint():
		return
	if (!auto_cycling and steps_left<1):
		return
	if (not body is GravitationalObject and not body is Minecart):
		return
	if exit_portal and not cooldown and  not body.invincible:
		body.global_position = exit_portal.get_node("TeleportPoint").global_position
		body.make_invincible(0.1)
		if retain_speed:
			body.linear_velocity = (-body.linear_velocity).rotated(Vector3.UP,transform.basis.z.signed_angle_to (exit_portal.transform.basis.z,Vector3.UP))
			body.angular_velocity = (-body.angular_velocity).rotated(Vector3.UP,transform.basis.z.signed_angle_to (exit_portal.transform.basis.z,Vector3.UP))
		else:
			body.linear_velocity = Vector3()
			body.angular_velocity = Vector3()
		$Teleport.start_playing()
		if body is Ball:
			get_tree().root.get_child(0).skins.stats.teleports_used+=1
			get_tree().root.get_child(0).skins.refresh()

func _exit_tree():
	if visualizer and is_instance_valid(visualizer):
		visualizer.clear_active_meshes()
		visualizer.queue_free()
