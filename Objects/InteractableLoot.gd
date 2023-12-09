class_name InteractableLoot extends Node3D


func enter_loot_box():
	$ShipRigidBody.process_mode = Node.PROCESS_MODE_INHERIT
	$SpaceVisuals.visible = false
	$ShipRigidBody.visible = true
	
	# TODO area / body for interacting / pick up ? 
	


func _on_interact_area_interacted():
	pass # Replace with function body.
