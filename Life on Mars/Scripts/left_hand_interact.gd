extends XRController3D

var activePointedObject = null

func _ready() -> void:
	connect("button_pressed", RightInteract)

func _physics_process(_delta: float) -> void:
	if $LeftHand/LeftPhysicsHand/RayCast3D.is_colliding():
		var c = $LeftHand/LeftPhysicsHand/RayCast3D.get_collider()
		activePointedObject = c
	else:
		activePointedObject = null

func RightInteract(name:String) -> void:
	if name == "trigger_click":
		activePointedObject.interact
