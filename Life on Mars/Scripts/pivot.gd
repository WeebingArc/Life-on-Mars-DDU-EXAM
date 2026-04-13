extends Node3D

signal lever_activated

@export var min_angle := -45.0
@export var max_angle := 45.0
@export var trigger_angle := 40.0

var current_angle := -45.0
var locked := false


func set_angle(angle):
	if locked:
		return  # stop all movement after locking

	current_angle = clamp(angle, min_angle, max_angle)
	rotation_degrees.x = current_angle

	# Check if pushed forward
	if current_angle >= trigger_angle:
		activate()


func activate():
	locked = true
	current_angle = max_angle
	rotation_degrees.x = max_angle
	emit_signal("lever_activated")
