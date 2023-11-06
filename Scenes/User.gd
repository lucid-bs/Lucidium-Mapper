extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.5
const inertia = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		var size = get_viewport().get_visible_rect().size
		var direction = Vector2(get_viewport().get_mouse_position())
		direction.x = ((direction.x / size.x) - 0.5) / -1
		direction.y = ((direction.y / size.y) - 0.5) / -1
		rotation+= Vector3(direction.y, direction.x, 0)
		#rotate_y(direction.x)
		#rotate_x(direction.y)
		get_viewport().warp_mouse(Vector2(size.x / 2, size.y / 2))
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	elif velocity.y > 0:
		velocity.y = clamp(velocity.y - inertia, 0, 3.5)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("fly_left", "fly_right", "fly_forwards", "fly_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if velocity.x != 0:
			velocity.x = clamp(velocity.x - inertia, 0, 5) if velocity.x > 0 else clamp(velocity.x - inertia, 0, -5)
			
		
		velocity.z = clamp(velocity.z - inertia, 0, 5)

	move_and_slide()
