extends Area2D

export var speed = 400
export var moving = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		$AnimatedSprite.play()
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	else:
		$AnimatedSprite.stop()
		$AudioStreamPlayer.stop()
