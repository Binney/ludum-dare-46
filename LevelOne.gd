extends Node2D

const WALKING_SPEED = 4
var current_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		start_moving()
	var scroll = Vector2(-current_speed * WALKING_SPEED, 0);
	$ParallaxBackground.scroll_offset += scroll
	

func start_moving():
	# qq play setting off animation or something
	current_speed = 1
	$Player.moving = true
