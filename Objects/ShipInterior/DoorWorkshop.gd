extends Node3D

const OPEN_WIDTH = .7

var tween: Tween

func open(_open := true):
	if tween != null:
		if tween.is_running():
			tween.stop()
	tween = get_tree().create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($DoorWorkshop/CockpitToWorkshopTransition/DoorWorkshopNeg, "position:x", -OPEN_WIDTH if _open else 0.0, 1.5)
	tween.tween_property($DoorWorkshop/CockpitToWorkshopTransition/DoorWorkshopPos, "position:x", OPEN_WIDTH if _open else 0.0, 1.5)

func close():
	open(false)

func _on_player_detection_body_entered(body):
	open()

func _on_player_detection_body_exited(body):
	close()
