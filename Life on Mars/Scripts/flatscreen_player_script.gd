extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 4.5
@export var mouse_senseitivity = 0.002

@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
var current_interactable = null

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cursor_locked = true

func _ready():
	camera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event.is_action_pressed("ui_alt"):
		toggle_cursor_mode()
		
	if cursor_locked and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_senseitivity)
		camera.rotate_x(-event.relative.y * mouse_senseitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	if event.is_action_pressed("activate") and is_on_floor():
		activate()
		
func _physics_process(delta):
	handle_input_and_movement(delta)
	move_and_slide()
	check_hover_collision()

func handle_input_and_movement(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if cursor_locked:
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.y, 0, speed)
	else: 
		velocity.x = 0
		velocity.z = 0

func check_hover_collision():
	if raycast.is_colliding():
		var hover_collider = raycast.get_collider()
		if hover_collider and is_instance_valid(hover_collider) and hover_collider.has_method("interact") and hover_collider.has_method("show_prompt"):
			if current_interactable != hover_collider:
				if current_interactable:
					current_interactable.hide_prompt()
				current_interactable = hover_collider
				current_interactable.show_prompt()
		else:
			hide_current_prompt()
	else:
		hide_current_prompt()

func hide_current_prompt():
	if current_interactable:
		current_interactable.hide_prompt()
		current_interactable = null

func activate():
	var hit = raycast.get_collider()
	if cursor_locked and raycast.is_colliding():
		if hit and hit.has_method("interact"):
			hit.interact()

func toggle_cursor_mode():
	cursor_locked = !cursor_locked
	if cursor_locked:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
