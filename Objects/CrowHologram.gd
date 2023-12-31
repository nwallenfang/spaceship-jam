class_name CrowHologram extends MeshInstance3D

@export var camera: Camera3D
@export var target_node: Node3D
@export var interpolation_speed: float = 1.5
@export var minimum_speed: float = 0.8
@onready var sphere_radius: float = target_node.global_position.distance_to(camera.global_position)

@export var angular_speed: float = 1.0


@onready var crows_ray: RayCast3D = $CrowsNestRay

func _process(delta):
	var camera_pos = camera.global_transform.origin
	# positions relative to center of sphere (CrowsCamera)
	var hologram_pos_rel = global_transform.origin - camera_pos
	var target_pos_rel = target_node.global_transform.origin - camera_pos
	# put both vectors on sphere surface (optional, just to make sure)
	var hologram = hologram_pos_rel.normalized() * sphere_radius
	var target = target_pos_rel.normalized() * sphere_radius
	var angle_distance = hologram.angle_to(target)
	var angle_rotate = min(angle_distance, delta * angular_speed)
	
	# rotate pivot
	var normal = hologram.cross(target).normalized()
	if not normal.is_zero_approx():
		get_parent().rotate(hologram.cross(target).normalized(), angle_rotate)
	set_rotation_away_from_camera()
	# check raycast
	if crows_ray.is_colliding():
		#var collider = crows_ray.get_collider()
		$SubViewport/Hologram/CrowsNestCrosshair.hitting_target = true
	else:
		$SubViewport/Hologram/CrowsNestCrosshair.hitting_target = false

func old_lerp_stuff(delta: float):
	var camera_pos = camera.global_transform.origin
	# positions relative to center of sphere (CrowsCamera)
	var hologram_pos_rel = global_transform.origin - camera_pos
	var target_pos_rel = target_node.global_transform.origin - camera_pos

	# put both vectors on sphere surface (optional, just to make sure)
	hologram_pos_rel = hologram_pos_rel.normalized() * sphere_radius
	target_pos_rel = target_pos_rel.normalized() * sphere_radius
	var distance_to_target = hologram_pos_rel.distance_to(target_pos_rel)
	var factor = delta * interpolation_speed * (distance_to_target / sphere_radius + minimum_speed)  # Ensuring a minimum factor
	factor = clamp(factor, 0.0, 1.0) 

	# slerp the position
	var new_pos_relative = hologram_pos_rel.slerp(target_pos_rel, factor)
	# relative to absolute position
	global_transform.origin = camera_pos + new_pos_relative
	
	# rotate Hologram so it's perpendicular to the Camera to it
	set_rotation_away_from_camera()	

func set_rotation_away_from_camera():
	var direction = (global_transform.origin - camera.global_transform.origin).normalized()
	var x_axis = direction.cross(Vector3.UP).normalized()
	var y_axis = x_axis.cross(direction).normalized()
	get_parent().global_transform.basis = Basis(x_axis, y_axis, -direction)
