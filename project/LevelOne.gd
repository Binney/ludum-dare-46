extends Node2D

const WALKING_SPEED = 1

const Mousician = preload('Mousician.gd')

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if (child is Mousician):
			child.play_loop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll = Vector2(WALKING_SPEED, 0);
	$ParallaxBackground.scroll_offset -= scroll
