extends ParallaxBackground

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# qq reinstate me
#	var tree_spawn = rng.randf()
#	if (tree_spawn<0.01):
#		$TreesClosest.add_child(new_random_tree())
#	elif (tree_spawn<0.02):
#		$TreesMiddle.add_child(new_random_tree())
#	elif (tree_spawn<0.03):
#		$TreesFar.add_child(new_random_tree())
	pass

#func new_random_tree():
#	var image = Image.new()
#	image.load("background/tree" + str(rng.randi_range(0, 4)) + ".png")
#	var texture = ImageTexture.new()
#	texture.create_from_image(image)
#	var sprite = Sprite.new()
#	sprite.texture = texture
#	sprite.centered = false
#	sprite.position = Vector2(35.423, 150) ## qq randomise
#	return sprite

#func recycle_old_trees():
	# qq need to manually remove any trees that have gone off the left hand side completely
#	pass
