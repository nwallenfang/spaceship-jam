extends Control


func _on_timer_timeout():
	%FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	%Resolution.text = "[%d, %d]" % [ProjectSettings.get("display/window/size/viewport_width"),
									 ProjectSettings.get("display/window/size/viewport_height")]
