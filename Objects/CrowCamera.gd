class_name CrowCamera extends Camera3D

@export_range(0.1, 3.0, 0.1, "or_greater")
var camera_sens: float = 1
var look_dir: Vector2

@export var hook_target: Marker3D

@export var fixed_camera: bool = false


func enable():
	process_mode = Node.PROCESS_MODE_INHERIT
	$HoloPivot.top_level = true
	$HoloPivot.visible = true
	$HoloPivot.global_position = self.global_position

func _rotate_camera(sens_mod: float = 1.0) -> void:
	rotation_degrees.y -= look_dir.x * camera_sens * sens_mod
	rotation_degrees.x = clamp(rotation_degrees.x - look_dir.y * camera_sens * sens_mod, -10, 85)

func _input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		# TODO need to find a way to capture it on clicking again / 
		#  or actually this where the pause menu should come
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.1
		_rotate_camera()
		
		
var last_target: LaserArea
func check_laser_target():
	if $HoloPivot/CrowsHologram/CrowsNestRay.is_colliding():
		# for now only Asteroids, need to add others
		# or introduce a group
		var target = $HoloPivot/CrowsHologram/CrowsNestRay.get_collider()
		if target == null or not target is LaserArea:
			# maybe (hopefully) got destroyed just this frame
			return
		target.get_parent().is_hit_by_laser = true
		
		if last_target != null and last_target != target:
			last_target.get_parent().is_hit_by_laser = false
		last_target = target
	else:
		if is_instance_valid(last_target) and last_target != null:
			last_target.get_parent().is_hit_by_laser = false
	
func stop_laser():
	if is_instance_valid(last_target) and last_target != null:
		last_target.get_parent().is_hit_by_laser = false
		last_target = null
			
func check_hook_target():
	# I would say for hooking you don't have to keep the button pressed
	if $HoloPivot/CrowsHologram/CrowsNestRay.is_colliding():
		var target = $HoloPivot/CrowsHologram/CrowsNestRay.get_collider()
		if target != null and target is HookArea:
			# maybe (hopefully) got destroyed just this frame
			var object = target.get_parent()
			var tween = create_tween()
			tween.tween_property(object, "global_transform", hook_target.global_transform, 2.0)
			await tween.finished
			object.visible = false
			Game.loot_queue.append(object)
