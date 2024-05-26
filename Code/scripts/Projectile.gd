extends RigidBody3D
class_name Projectile

@export var momentum : float = .7

func add_ignore(node:Node3D):
	$KillZone.ignore_list.append(node)

func on_body_entered(body: Node3D):
	if body is GravitationalObject:
		body.apply_impulse(momentum*linear_velocity)
