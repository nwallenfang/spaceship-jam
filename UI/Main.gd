extends Control


func _unhandled_input(event):
	# dumm, dumm, dumm
	# aber glaube das ist workaround für diesen bug....
	# https://github.com/godotengine/godot/issues/84258
	# deswegen mouse event hier fangen und an den viewport/cam weitergeben
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		var current_cam = $SubViewportContainer/SubViewport.get_camera_3d()
		if current_cam is PlayerCamera:  # TODO and Game active/not paused/ etc.
			current_cam.look_dir = event.relative * 0.1
			current_cam._rotate_camera()
