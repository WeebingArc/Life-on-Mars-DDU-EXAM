extends XRController3D

var activePointedObject = null

signal play_intro

func _ready() -> void:
	connect("button_pressed", RightInteract)

func _physics_process(_delta: float) -> void:
	if $RayCast3D.is_colliding():
		var c = $RayCast3D.get_collider()
		activePointedObject = c
	else:
		activePointedObject = null

func RightInteract(name:String) -> void:
	if name == "trigger_click":
		if activePointedObject:
			emit_signal("play_intro")
