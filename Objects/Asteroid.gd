class_name Asteroid extends Node3D

const MAX_HP = 100.0
const LASER_DRAIN = 35.0
const REGENERATION = 25.0

const FuelScene = preload("res://Objects/FuelDrop.tscn")
const GearScene = preload("res://Objects/GearDrop.tscn")

enum Drop {
	NOTHING,
	FUEL,
	GEAR
}

@export var drop: Drop = Drop.NOTHING



var is_hit_by_laser := false
var hp := MAX_HP

func _physics_process(delta: float):
	damage_process(delta)

func damage_process(delta: float):
	if is_hit_by_laser:
		hp -= LASER_DRAIN * delta
		if hp <= 0.0:
			destroy()
	else:
		if hp < MAX_HP:
			hp = min(MAX_HP, hp + REGENERATION * delta)
	
	for m in %Model.get_children():
		if m is MeshInstance3D:
			m.material_overlay.set("shader_parameter/crack_progress", 1.0 - hp / MAX_HP)

func destroy():
	match drop:
		Drop.FUEL:
			var fuel = FuelScene.instantiate()
			get_parent().add_child(fuel)
			fuel.global_position = global_position
		Drop.GEAR:
			var gear = GearScene.instantiate()
			get_parent().add_child(gear)
			gear.global_position = global_position
	
	queue_free()
