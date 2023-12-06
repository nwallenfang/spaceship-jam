class_name Player extends CharacterBody3D 

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.1

@export var ground_friction := 0.1
@export var air_friction := 0.05

@onready var raycast = $Smoothing/PlayerCamera/InteractRayCast


var currently_hovering: InteractArea = null
signal hover_interaction_with(action_hint: String)
signal stop_hover_interaction_with


enum PlayerState {
	FREE_MOVE,
	IN_CROWS_NEST
}

var player_state: PlayerState = PlayerState.FREE_MOVE: 
	set(new_state):
		if new_state == PlayerState.IN_CROWS_NEST:
			# idk ?? ? ?
			player_state = new_state
		else:
			player_state = new_state


func _ready():
	if Game.player == null:
		Game.player = self
	else:
		printerr("More than one player!")
	$DebugMesh.visible = false
	

func _physics_process(delta):
	var movement = Vector3()
	
	if player_state != PlayerState.FREE_MOVE:
		return

	if Input.is_action_pressed("move_left"):
		movement.x -= 1.0
	if Input.is_action_pressed("move_right"):
		movement.x += 1.0
	if Input.is_action_pressed("move_forward"):
		movement.z -= 1.0
	if Input.is_action_pressed("move_backwards"):
		movement.z += 1.0
	

	var yaw_rotation = Basis(Vector3.UP, rotation.y)
	movement = (yaw_rotation * movement).normalized() * speed * delta
	global_transform.origin += movement
	
	move_and_slide()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		assert(collider is InteractArea)
		
		if currently_hovering == null or currently_hovering != collider:
			currently_hovering = collider
			hover_interaction_with.emit(currently_hovering.action_hint)
	else:
		if currently_hovering != null:
			currently_hovering = null
			stop_hover_interaction_with.emit()
	
	if Input.is_action_just_pressed("interact") and currently_hovering != null:
		currently_hovering.interacted.emit()
	

