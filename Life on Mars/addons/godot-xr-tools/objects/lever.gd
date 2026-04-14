extends RigidBody3D

signal lever_activated

@export var min_angle := -45.0
@export var max_angle := 45.0
@export var trigger_angle := 40.0

var start_position : Vector3
var locked := false


func _ready():
	start_position = global_position

	# Lock all movement (so it doesn't fly away)
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true

	# Allow ONLY one rotation axis (change if needed)
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	# X is free (for forward/back lever)


func _physics_process(delta):
	# Keep it fixed in place
	global_position = start_position

	if locked:
		rotation_degrees.x = max_angle
		return

	# Clamp rotation
	var rot = rotation_degrees.x
	rot = clamp(rot, min_angle, max_angle)
	rotation_degrees.x = rot

	# Check if pushed forward
	if rot >= trigger_angle:
		activate()


func activate():
	locked = true
	rotation_degrees.x = max_angle
	emit_signal("lever_activated")
