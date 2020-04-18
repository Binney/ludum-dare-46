extends Area2D

export var speed = 400
export var moving = false
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
