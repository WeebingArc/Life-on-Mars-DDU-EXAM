extends Node3D

var grabbing := false
var can_grab := false

@onready var lever = $"../Pivot"
@onready var hand = $"../RightHand"

var last_hand_y := 0.0


func _process(delta):
	if can_grab and Input.is_action_pressed("trigger") and !lever.is_locked:
		if !grabbing:
			grabbing = true
			last_hand_y = hand.global_position.y

		var delta_y = hand.global_position.y - last_hand_y
		lever.current_angle += delta_y * 100.0
		lever.set_lever_angle(lever.current_angle)

		last_hand_y = hand.global_position.y
	else:
		grabbing = false
