extends Node3D
class_name Visualizer

var active_meshes : Array[MeshInstance3D] = []

func draw_line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, _persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	material.render_priority=127
	
	get_parent().add_child(mesh_instance)
	active_meshes.append(mesh_instance)

func draw_point(pos:Vector3, radius = 0.35, color = Color.WHITE_SMOKE, _persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()
		
	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos
	
	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_parent().add_child(mesh_instance)
	active_meshes.append(mesh_instance)

func draw_circumference(origin:Vector3,start_vector:Vector3,end_vector:Vector3,radius:float,steps := 10):
	var prev = start_vector*radius
	var next : Vector3
	var rotation_axis = start_vector.cross(end_vector)
	if (rotation_axis ==Vector3(0,0,0)):
		return
	rotation_axis =rotation_axis.normalized()
	var arc = start_vector.angle_to(end_vector)
	for i in range(steps):
		next = prev.rotated(rotation_axis,1.0/steps*arc)
		draw_line(prev+origin,next+origin)
		prev=next

func draw_arrow(start : Vector3,end : Vector3, color := Color.WHITE_SMOKE, head_length := 2.0, head_angle_rad := 0.3):
	draw_line(start, end, color)
	var head : Vector3 = -end.normalized() * head_length
	draw_line(end, end + head.rotated(Vector3.UP,head_angle_rad +end.angle_to(start)),  color)
	draw_line(end, end + head.rotated(Vector3.UP,-head_angle_rad+end.angle_to(start)),  color)

func clear_active_meshes():
	for mesh in active_meshes:
		mesh.queue_free()
	active_meshes =[]

func _exit_tree():
	clear_active_meshes()
