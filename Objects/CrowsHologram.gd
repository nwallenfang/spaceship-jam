class_name CrowsHologram extends MeshInstance3D

@export var camera: Camera3D
@export var target_node: Node3D
@export var interpolation_speed: float = 0.9
@onready var sphere_radius: float = target_node.global_position.distance_to(camera.global_position)

func _process(delta):
	var camera_pos = camera.global_transform.origin
	var hologram_pos_rel = global_transform.origin - camera_pos
	var target_pos_rel = target_node.global_transform.origin - camera_pos

	# put both vectors on sphere surface (optional, just to make sure)
	hologram_pos_rel = hologram_pos_rel.normalized() * sphere_radius
	target_pos_rel = target_pos_rel.normalized() * sphere_radius

	# slerp the position
	var new_pos_relative = hologram_pos_rel.slerp(target_pos_rel, interpolation_speed * delta)
	global_transform.origin = camera_pos + new_pos_relative
	
	# rotate Hologram so it's perpendicular to the Camera to it
	set_rotation_away_from_camera()

func set_rotation_away_from_camera():
	var direction = (global_transform.origin - camera.global_transform.origin).normalized()
	var x_axis = direction.cross(Vector3.UP).normalized()
	var y_axis = x_axis.cross(direction).normalized()
	global_transform.basis = Basis(x_axis, y_axis, -direction)
