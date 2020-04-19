extends Area2D

signal cancel

func _input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch && event.is_pressed()):
		emit_signal("cancel")
	
