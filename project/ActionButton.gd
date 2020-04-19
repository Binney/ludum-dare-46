extends Area2D

export(String) var action

signal performAction

func _ready():
	$AnimatedSprite.play(action)

func _input_event(viewport, event, shape_idx):
	if (event is InputEventScreenTouch):
		emit_signal("performAction")
	
