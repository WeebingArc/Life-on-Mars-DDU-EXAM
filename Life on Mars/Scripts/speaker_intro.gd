extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../StaticBody3D".connect("play_intro", play_intro)

func play_intro():
	play(true)
