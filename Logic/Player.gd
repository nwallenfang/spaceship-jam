class_name Player extends CharacterBody3D 

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.1

@export var ground_friction := 0.1
@export var air_friction := 0.05

@onready var raycast = $Smoothing/PlayerCamera/InteractRayCast

# no movement / interaction
var blocked = false


var currently_hovering: InteractArea = null
signal hover_interaction_with(action_hint: String)
signal stop_hover_interaction_with

signal start_entering_crows_nest
signal entered_crows_nest
signal exited_crows_nest

enum PlayerState {
	FREE_MOVE,
	IN_CROWS_NEST
}

var player_state: PlayerState = PlayerState.FREE_MOVE: 
	set(new_state):
		#print("SET to ", PlayerState.keys()[new_state])
		if player_state == new_state:
			if new_state == PlayerState.IN_CROWS_NEST:
				printerr("set to same player state " + PlayerState.keys()[new_state])
		#if new_state == PlayerState.IN_CROWS_NEST:
			#entered_crows_nest.emit()


		player_state = new_state
			

func _ready():
	if Game.player == null:
		Game.player = self
	else:
		printerr("More than one player!")
	$DebugMesh.visible = false
	

var prev_camera_transform: Transform3D
var crow_cam: Camera3D
func enter_crows_nest(crow_cam_ref: Camera3D):
	start_entering_crows_nest.emit()
	crow_cam = crow_cam_ref
	player_state = Player.PlayerState.IN_CROWS_NEST
	# block player from moving during the anim
	blocked = true

	prev_camera_transform = crow_cam.transform
	crow_cam.make_current()
	# small delay
	await get_tree().create_timer(.4).timeout
	# lerp crow cam upwards to the final position
	var target = crow_cam.transform.translated(Vector3(0.0, 4.0, 0.0))
	var tween = create_tween()
	tween.tween_property(crow_cam, "transform", target, 3.0).set_trans(Tween.TRANS_QUAD)
	
	# unblock player afterwards
	await tween.finished
	blocked = false
	entered_crows_nest.emit()
	crow_cam.enable()
	
func exit_crows_next_animation():
	# TODO go downwards again, lerp cameras maybe
	crow_cam.transform = prev_camera_transform
	$Smoothing/PlayerCamera.make_current()
	crow_cam.process_mode = Node.PROCESS_MODE_DISABLED
	
	player_state = PlayerState.FREE_MOVE

func _physics_process(delta):
	var movement = Vector3()
	if blocked:
		return

	if player_state == PlayerState.IN_CROWS_NEST:
		if Input.is_action_just_pressed("interact"):
			exited_crows_nest.emit()
			exit_crows_next_animation()
			return
	
	if player_state == PlayerState.FREE_MOVE:
		if Input.is_action_pressed("move_left"):
			movement.x -= 1.0
		if Input.is_action_pressed("move_right"):
			movement.x += 1.0
		if Input.is_action_pressed("move_forward"):
			movement.z -= 1.0
		if Input.is_action_pressed("move_backwards"):
			movement.z += 1.0
		if Input.is_action_just_pressed("interact") and currently_hovering != null:
			print("Player: emit interacted")
			currently_hovering.interacted.emit()
	

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

