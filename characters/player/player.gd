extends CharacterBody3D


const SPEED = 5.0
const RUN_SPEED = 10.0
const JUMP_VELOCITY = 4.5

const CAMERA_SENSIBILITY = 0.4
@onready var camera = $CameraPivot

func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * CAMERA_SENSIBILITY)) # X: on the screen horizontal
		camera.rotate_x(deg_to_rad(-event.relative.y * CAMERA_SENSIBILITY)) # Y: on the screen vertical
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-20), deg_to_rad(45)) # Prevent complete flip
		
func movement(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("KEY_A", "KEY_D", "KEY_W", "KEY_S")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed = SPEED
	if Input.is_key_pressed(KEY_SHIFT):
		speed = RUN_SPEED
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	
