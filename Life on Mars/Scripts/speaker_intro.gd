extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../XROrigin3D/Right Controller".connect("play_intro", play_intro)

func play_intro():
	play(true)
