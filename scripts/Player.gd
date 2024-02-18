extends CharacterBody3D

@onready var head = $Head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var ray_cast_3d = $RayCast3D

# Using lerp function to add gradual speed rather than snappy constant speed on movement
var lerp_speed = 10.0

# Camera sensitivity
var mouse_sensitivity = 0.25

# Default player camera Y position (according to Camera3D node)
var HEAD_POSITION_Y = 0.8

# Player movement speed
var current_speed = 5.0
const WALKING_SPEED = 5.0
const SPRINTING_SPEED = 8.0
const CROUCHING_SPEED = 3.0

# Changes the player's Y position (also, character collision shape) when crouching
var crouching_depth = 0.5

# Determine how high the player's jump 
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var gravity_multiplier = 2

# Initialize direction
var direction = Vector3.ZERO


func _ready():
	# Capture mouse input and lock it inside app window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Player camera POV
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		# Crouching state
		head.position.y = lerp(head.position.y, HEAD_POSITION_Y - crouching_depth, delta * lerp_speed)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		current_speed = CROUCHING_SPEED
	elif !ray_cast_3d.is_colliding():
		# Standing state (only when RayCast3D detects no object/collision above player's head)
		head.position.y = lerp(head.position.y, HEAD_POSITION_Y, delta * lerp_speed)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		
		if Input.is_action_pressed("sprint"):
			current_speed = SPRINTING_SPEED
		else:
			current_speed = WALKING_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * gravity_multiplier

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
