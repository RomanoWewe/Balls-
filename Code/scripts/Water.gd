extends AnimatableBody3D
class_name Water

@export var show_visuals:=true : set = set_visible_visuals
var bodies_affected := []
var aabb : AABB
@export var LINEAR_DAMP := 0.996


func _ready():
	aabb = $mesh2.get_aabb()
	aabb.position+=$mesh2.position+position

func _physics_process(delta):
	for body in bodies_affected:
		body.linear_velocity *= LINEAR_DAMP
		body.apply_force(get_body_submerge_percentage(body)*body.mass*
		Vector3.UP*body.buoyancy*body.gravity_scale*9.8)

func set_visible_visuals(new_value:bool):
	show_visuals = new_value
	$mesh.visible = new_value

func _on_area_3d_body_entered(body):
	if body is GravitationalObject:
		bodies_affected.append(body)
		if body.waters_intersected.size()<1 and body.linear_velocity.length()>=2:
			if get_node_or_null("Splash") !=null:
				$Splash.start_playing()
		body.waters_intersected.append(self)
		if body is Ball:
			body.amount_of_ground_contacted+=1
			body.is_affected_by_tilt = true

func _on_area_3d_body_exited(body):
	if bodies_affected.has(body):
		bodies_affected.erase(body)
		body.waters_intersected.erase(self)
		if body is Ball:
			body.amount_of_ground_contacted-=1

func get_body_submerge_percentage(body : Node3D):
	if !body.has_node("mesh"):
		return 0
	var body_aabb = body.get_node("mesh").get_aabb() as AABB
	body_aabb.position+=body.get_node("mesh").global_position
	return body_aabb.intersection(aabb).get_volume()/body_aabb.get_volume()
