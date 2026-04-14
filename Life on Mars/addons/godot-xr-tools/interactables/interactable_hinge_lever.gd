extends XRToolsInteractableHinge

signal lever_activated

@export var trigger_angle := 40.0

var locked := false


func _ready():
	super()
	hinge_moved.connect(_on_hinge_moved)


func _on_hinge_moved(angle):
	if locked:
		return

	if angle >= trigger_angle:
		activate()


func activate():
	locked = true

	# Snap to max position
	move_hinge(deg_to_rad(hinge_limit_max))

	# Stop further interaction
	process_mode = Node.PROCESS_MODE_DISABLED

	emit_signal("lever_activated")
