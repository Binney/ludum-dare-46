extends Node2D

const WALKING_SPEED = 1

const Mousician = preload('Mousician.gd')

var sad_time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value += delta

	if ($ProgressBar.value == $ProgressBar.max_value):
		get_tree().get_root().get_child(0).last_level_score = 100 * (($ProgressBar.max_value - sad_time) / $ProgressBar.max_value)
		get_tree().change_scene('res://GameOver.tscn')
	
	var scroll = Vector2(WALKING_SPEED, 0);
	$CountrysideBackground.scroll_offset -= scroll
	var is_sad = false;
	for child in get_children():
		if (child is Mousician && child.is_sad()):
			is_sad = true
			break
			
	if is_sad:
		sad_time += delta
			
	$ProgressBar.set_is_sad(is_sad)
