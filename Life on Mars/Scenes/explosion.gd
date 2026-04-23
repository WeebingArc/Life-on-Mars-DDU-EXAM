extends AudioStreamPlayer


func _ready() -> void:
	$"../Habitat/Spoker/AudioStreamPlayer3D".connect("finished", play_audio)

func play_audio():
	play(true)
