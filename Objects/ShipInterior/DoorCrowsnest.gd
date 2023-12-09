extends Node3D

func open():
	$AnimationPlayer.play("open")

func close():
	$AnimationPlayer.play("close")


func _ready():
	while true:
		open()
		await get_tree().create_timer(3).timeout
		close()
		await get_tree().create_timer(3).timeout
