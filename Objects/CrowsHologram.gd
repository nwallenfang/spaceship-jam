class_name CrowsHologram extends MeshInstance3D

@export var target_node: Node3D
@export var lerp_speed: float = 0.1

func _ready():
	pass

func _process(delta):
	global_transform = global_transform.interpolate_with(target_node.global_transform, lerp_speed * delta)

