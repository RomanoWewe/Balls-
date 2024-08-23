extends CharacterBody3D
class_name AIAngel

@export var speed = 10
@export var accel = 10
@export var stop_range = 10

# the vars which make you do the thing where you do the thing
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var ball: Ball
var lights_count:=0

func _ready():
	for child in get_parent().get_children():
		if child is Ball:
			ball=child
			return
	push_error("Ball Not found on level!")

# the stupid physics stuff
func _physics_process(delta):
	if !NavigationServer3D.map_is_active(RID(agent.get_navigation_map())):
		return
	if lights_count>0:
		return
	var direction = Vector3()
	agent.target_position = ball.global_position # this one needs the @onready vars we defined earlier
	direction = agent.get_next_path_position() - position # and so does this
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
