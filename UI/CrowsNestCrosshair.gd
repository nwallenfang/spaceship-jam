extends Control

@export var default_color: Color = Color.WHITE
@export var hitting_color: Color = Color.BLUE_VIOLET

var hitting_target: bool = false:
	set(b):
		hitting_target = b
		if b:
			$CrosshairContainer/CrosshairTexture.modulate = hitting_color
		else:
			$CrosshairContainer/CrosshairTexture.modulate = default_color
