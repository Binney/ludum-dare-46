extends Area2D

signal performAction

func _input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch):
		emit_signal("performAction")
	
