extends StaticBody3D

@onready var prompt_label : Label3D = $Label3D

signal play_power_restart
signal explosion

func _ready() -> void:
	$"../Spoker/AudioStreamPlayer3D".connect("finished", ending_explosion)
	$"../../explosion".connect("finished", kill_game)

func ending_explosion():
	await(15)
	emit_signal("explosion")
	
func kill_game():
	get_tree().quit()

func interact():
	emit_signal("play_power_restart")

func show_prompt():
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
