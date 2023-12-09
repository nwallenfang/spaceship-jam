class_name LootStation extends Node3D

@export var trigger_spawn_area: Area3D

func _ready():
	trigger_spawn_area.body_entered.connect(spawn_loot_queue_items)

func spawn_loot_queue_items(_body):
	# body should be the player
	print(Game.loot_queue)
	for loot in Game.loot_queue:
		loot.visible = true
		loot.global_position = $SpawnPosition.global_position
		#if loot.has_node("InteractableLoot"):
		loot.enter_loot_box()
		await get_tree().create_timer(.4).timeout
