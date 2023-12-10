extends Area3D
class_name InteractArea

@export var action_hint: String = "Interact"

signal interacted
## when the player hovers, refresh the boolean
signal requesting_is_interactable_update

## Change this on the fly based on some condition
@export var is_interactable: bool = true
@export var not_interactable_message := "Can't interact"
