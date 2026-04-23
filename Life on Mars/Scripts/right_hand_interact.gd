extends XRController3D

@onready var raycast = $RayCast3D

var current_interactable = null
var activePointedObject = null

func _ready() -> void:
	connect("button_pressed", RightInteract)

func _physics_process(_delta: float) -> void:
	check_hover_collision()

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

func RightInteract(name:String) -> void:
	if name == "trigger_click" and raycast.is_colliding():
		activate()

func activate():
	var hit = raycast.get_collider()
	if raycast.is_colliding():
		if hit and hit.has_method("interact"):
			hit.interact()
