extends Node

var player: Player = null

var ui: UI = null


enum State {
	IN_MAIN_MENU,
	PLAYING,
}

var state: State

var fuel_level: int

var loot_queue: Array[Node3D] = []


func _ready() -> void:
	if OS.is_debug_build():
		state = State.PLAYING  # TODO transitions
	else:
		state = State.IN_MAIN_MENU
