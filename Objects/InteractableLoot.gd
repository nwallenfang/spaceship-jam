class_name InteractableLoot extends RigidBody3D

func enter_loot_box():
	self.freeze = false
	$SpaceVisuals.visible = false
	$ShipVisuals.visible = true

func _on_interact_area_interacted():
	if Game.player.currently_holding == null:
		self.freeze = true
		print("freeze: ", self.freeze)
		$ShipVisuals/InteractArea.collision_layer = 0
		Game.player.currently_holding = self

func _on_interact_area_requesting_is_interactable_update():
	if Game.player.currently_holding == null:
		$ShipVisuals/InteractArea.is_interactable = true
	else:
		$ShipVisuals/InteractArea.is_interactable = false
