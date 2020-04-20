extends Area2D

const RandomMouse = preload('RandomMouse.gd')

var rng = RandomNumberGenerator.new()

const random_mice = []

func _ready():
	rng.randomize()
	for child in get_children():
		if (child is RandomMouse):
			random_mice.append(child.get_index())
	randomise()

func randomise():
	var random_mouse_index = random_mice[rng.randi_range(0, random_mice.size() - 1)];
	var random_mouse = get_child(random_mouse_index)
	$AnimatedSprite.frames = random_mouse.sprite
	random_mouse.stream.loop = true
	$AudioStreamPlayer.stream = random_mouse.stream
	$AudioStreamPlayer.play()
