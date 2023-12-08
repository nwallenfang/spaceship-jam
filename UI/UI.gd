extends Control
class_name UI

func _ready(): 
	if Game.player != null:
		Game.player.hover_interaction_with.connect(start_interaction)
		Game.player.stop_hover_interaction_with.connect(stop_interaction)
		Game.player.entered_crows_nest.connect(enter_crows_nest)
		Game.player.start_entering_crows_nest.connect(start_enter_crows_nest)
		Game.player.exited_crows_nest.connect(exit_crows_nest)
	else:
		printerr("UI not wired up to Player.")



func start_interaction(action_hint: String):
	%InteractLabel.text = "[E] " + action_hint
	%InteractLabel.visible = true
	
	
func stop_interaction():
	%InteractLabel.visible = false
	
func start_enter_crows_nest():
	%InteractLabel.visible = false
	$Crosshair.visible = false

func enter_crows_nest():
	%ExitLabel.visible = true
	
func exit_crows_nest():
	%ExitLabel.visible = false
	$Crosshair.visible = true


func _on_timer_timeout():
	%FPS.text = "FPS: %s" % Engine.get_frames_per_second()
	%Resolution.text = "[%d, %d]" % [ProjectSettings.get("display/window/size/viewport_width"),
									 ProjectSettings.get("display/window/size/viewport_height")]
	if Game.player != null:					
		%PlayerState.text = "Player: %s" % Game.player.PlayerState.keys()[Game.player.player_state]
