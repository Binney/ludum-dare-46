extends Node2D

const WALKING_SPEED = 1

const Mousician = preload('Mousician.gd')

var sad_time = 0
var total_time = 0

var intro_length = 0
var loop_length = 0

var target_positions = {}
var start_positions = {}
const INITIAL_START_POSITION = -140

func _ready():
	var max_walk_distance = 0
	var child_count = 0
	
	for child in get_children():
		if (child is Mousician):
			child_count += 1
			intro_length = max(intro_length, child.intro_track.get_length())
			loop_length = max(loop_length, child.loop_track.get_length())
			max_walk_distance = max(max_walk_distance, child.position.x)

	for child in get_children():
		if (child is Mousician):
			child.sadness_chance_per_second = 0.5 / child_count
			target_positions[child] = child.position.x
			var start_position_x = child.position.x - max_walk_distance + INITIAL_START_POSITION
			start_positions[child] = start_position_x
			child.position.x = start_position_x

	$ProgressBar.max_value = 4 * loop_length

func _process(delta):
	total_time += delta
	
	if (total_time > intro_length):
		$ProgressBar.value += delta
		if ($ProgressBar.value == $ProgressBar.max_value):
			var player_state = get_tree().get_root().get_child(0)
			player_state.set_level_score(100 * ($ProgressBar.max_value - sad_time) / $ProgressBar.max_value)
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
		
	else:
		var intro_progress = total_time / intro_length
		for child in get_children():
			if (child is Mousician):
				child.position.x = start_positions[child] + (intro_progress * (target_positions[child] - start_positions[child]))
