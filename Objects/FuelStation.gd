class_name FuelStation extends Node3D

func _on_interact_area_requesting_is_interactable_update():
	print("supp")
	$InteractArea.is_interactable = Game.player.currently_holding is FuelDrop


func _on_interact_area_interacted():
	# TODO remove fuel crystal from player and increase fuel level
	# play some animation
	var fuel_drop: FuelDrop = Game.player.currently_holding as FuelDrop
	assert(fuel_drop != null)
	Game.player.currently_holding = null
	fuel_drop.queue_free()
