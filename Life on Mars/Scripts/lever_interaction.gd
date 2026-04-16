extends StaticBody3D

@onready var prompt_label : Label3D = $Label3D

signal play_intro

func _ready() -> void:
	$"../Spoker/AudioStreamPlayer3D".connect("finished", next_scene)

func next_scene():
	get_tree().change_scene_to_file("res://Scenes/node_3d.tscn")

func interact():
	emit_signal("play_intro")

func show_prompt():
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
