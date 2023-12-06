extends Node

var player: Player = null


enum State {
	IN_MAIN_MENU,
	PLAYING,
}

var state: State

func _ready() -> void:
	if OS.is_debug_build():
		state = State.PLAYING  # TODO transitions
	else:
		state = State.IN_MAIN_MENU
