extends Control
class_name UI

func _ready(): 
	if Game.player != null:
		Game.player.hover_interaction_with.connect(start_interaction)
		Game.player.stop_hover_interaction_with.connect(stop_interaction)



func start_interaction(action_hint: String):
	print("start interacting")
	%InteractLabel.text = "[E] " + action_hint
	%InteractLabel.visible = true
	
	
func stop_interaction():
	print("stop interacting")
	%InteractLabel.visible = false


func _on_timer_timeout():
	%FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	%Resolution.text = "[%d, %d]" % [ProjectSettings.get("display/window/size/viewport_width"),
									 ProjectSettings.get("display/window/size/viewport_height")]
