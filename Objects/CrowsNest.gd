extends Node3D


func _on_interact_area_interacted() -> void:
	# Disable player movement, lock in, allow for asteroids to be picked
	if Game.player != null:
		Game.player.enter_crows_nest($CrowsCamera)
		#$CrowsCamera.make_current()
