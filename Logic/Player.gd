extends CharacterBody3D

@export var speed: float = 5.0
@export var mouse_sensitivity: float = 0.1

@export var ground_friction := 0.1
@export var air_friction := 0.05


func accelerate(_old_velocity: Vector3, direction: Vector3, delta: float) -> Vector3:
	# Using only the horizontal velocity, interpolate towards the input.
	# apply ground friction if on floor
	if is_on_floor():
		velocity = velocity * pow((1.0 - ground_friction), delta * 60)
	else:
		velocity = velocity * pow((1.0 - air_friction), delta * 60)
	velocity += speed * direction * delta
	
	return velocity


func _physics_process(delta):
	var movement = Vector3()

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
