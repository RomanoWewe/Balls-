extends RigidBody3D
class_name AICultist

@export var speed = 10
@export var accel = 10
@export var stop_range = 10

# the vars which make you do the thing where you do the thing
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var ball: Ball

func _ready():
	for child in get_parent().get_children():
		if child is Ball:
			ball=child
			return
	agent.set_navigation_map(get_tree().get_child(0).get_node("CultistNavigationRegion3D").get_navigation_map())
	push_error("Ball Not found on level!")

# the stupid physics stuff
func _physics_process(delta):
	if !NavigationServer3D.map_is_active(RID(agent.get_navigation_map())) or !is_instance_valid(ball):
		return
	var direction = Vector3()
	agent.target_position = ball.global_position # this one needs the @onready vars we defined earlier
	direction = agent.get_next_path_position() - position # and so does this
	direction = direction.normalized()
	basis=basis.slerp(basis.rotated(Vector3.UP, basis.z.signed_angle_to(direction,Vector3.UP)),.1)
	if accel>0:
		linear_velocity = linear_velocity.lerp(direction * speed, accel * delta)
	else:
		linear_velocity = direction * speed


func _on_body_entered(body: Node) -> void:
	if body is Ball:
		body.hit(self)
