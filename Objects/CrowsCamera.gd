class_name CrowsCamera extends Camera3D

@export_range(0.1, 3.0, 0.1, "or_greater")
var camera_sens: float = 1
var look_dir: Vector2


func enable():
	process_mode = Node.PROCESS_MODE_INHERIT
	$CrowsHologram.top_level = true

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
