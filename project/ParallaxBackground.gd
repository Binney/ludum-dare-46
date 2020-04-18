extends ParallaxBackground

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tree_spawn = rng.randf()
	if (tree_spawn<0.01):
		print("Spawned a tree!")
		$TreesClosest.add_child(new_random_tree())
		pass
	elif (tree_spawn<0.02):
		pass # spawn tree on trees_middle
	elif (tree_spawn<0.03):
		pass # spawn tree on trees_far
	pass

func new_random_tree():
	var image = Image.new()
	image.load("background/tree0") ## qq randomise
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	var sprite = Sprite.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2(35.423, 150) ## qq randomise
	return sprite
