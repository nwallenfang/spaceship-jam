extends Camera3D
class_name PlayerCamera

@export_range(0.1, 3.0, 0.1, "or_greater")
var camera_sens: float = 1

# Variables for mouse look
var pitch: float = 0.0
var yaw: float = 0.0
var look_dir: Vector2 # Input direction for look/aim

@export var pivot: Node3D

# To hide the cursor and capture mouse input
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _rotate_camera(sens_mod: float = 1.0) -> void:
	pivot.rotation_degrees.y -= look_dir.x * camera_sens * sens_mod
	rotation_degrees.x = clamp(rotation_degrees.x - look_dir.y * camera_sens * sens_mod, -85, 85) # We use degrees here and adjust the range to [-85, 85] to prevent full vertical rotation

func _input(event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		# TODO need to find a way to capture it on clicking again / 
		#  or actually this where the pause menu should come
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		print("oyy nice")
		look_dir = event.relative * 0.1
		_rotate_camera()
