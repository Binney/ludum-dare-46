extends Area2D

export(String) var instrument
export(AudioStream) var intro_track
export(AudioStream) var loop_track
export var is_percussion = false

const SADNESS_CHANCE_PER_SECOND = 0.1
var rng = RandomNumberGenerator.new()

var pitch_offset = 0
var time_offset = 0
var touch_start
var track_start_time

func _ready():
	rng.randomize()
	$AnimatedSprite.play("happy_" + instrument)

func _process(delta):
	if ((!is_sad()) && (rng.randf() < (SADNESS_CHANCE_PER_SECOND * delta))):
		become_sad()
		
	if (is_percussion && time_offset != 0):
		$AudioStreamPlayer.pitch_scale += (time_offset * delta / 50)

func is_open_menu_event(event):
	return event is InputEventScreenTouch && event.is_pressed()

func _input_event(viewport, event, shape_idx):
	if (!$ActionMenu.visible && is_open_menu_event(event)):
		var absolute_event_position = event.get_position()
		show_menu(absolute_event_position - global_position)

func is_sad():
	return time_offset != 0 || pitch_offset != 0

func play_loop():
	$AudioStreamPlayer.stream = loop_track
	track_start_time = OS.get_ticks_usec()
	$AudioStreamPlayer.play()

func become_sad():
	match (rng.randi_range(0, 1 if is_percussion else 3)):
		0:
			time_offset = 1
		1:
			time_offset = -1
		2:
			pitch_offset = 1
		3:
			pitch_offset = -1
	update_output()

func update_output():
	match [pitch_offset, time_offset]:
		[0, 0]:
			$AnimatedSprite.play("happy_" + instrument)
			$AudioStreamPlayer.pitch_scale = 1
			resync_track()
			$AudioStreamPlayer.bus = "Healthy"
		[-1, 0]:
			$AnimatedSprite.play("sad_" + instrument)
			$AudioStreamPlayer.pitch_scale = 1
			resync_track()
			$AudioStreamPlayer.bus = "Flat"
		[1, 0]:
			$AnimatedSprite.play("sad_" + instrument)
			$AudioStreamPlayer.pitch_scale = 1
			resync_track()
			$AudioStreamPlayer.bus = "Sharp"
		[0, -1]:
			$AnimatedSprite.play("sad_" + instrument)
			if (is_percussion):
				$AudioStreamPlayer.pitch_scale = 1
				resync_track()
				$AudioStreamPlayer.bus = "Healthy"
			else:
				$AudioStreamPlayer.pitch_scale = pow(2, -1/float(12))
				$AudioStreamPlayer.bus = "Sharp"
		[0, 1]:
			$AnimatedSprite.play("sad_" + instrument)
			if (is_percussion):
				$AudioStreamPlayer.pitch_scale = 1
				resync_track()
				$AudioStreamPlayer.bus = "Healthy"
			else:
				$AudioStreamPlayer.pitch_scale = pow(2, 1/float(12))
				$AudioStreamPlayer.bus = "Flat"

func resync_track():
	var elapsedMicroseconds = OS.get_ticks_usec() - track_start_time
	var elapsedSeconds = elapsedMicroseconds / float(1000000)
	var loopOffset = fmod(elapsedSeconds, $AudioStreamPlayer.stream.get_length())
	$AudioStreamPlayer.seek(loopOffset)

func _on_Sharpen_performAction():
	if (pitch_offset < 0):
		pitch_offset = 0
	update_output()
	hide_menu()

func _on_Flatten_performAction():
	if (pitch_offset > 0):
		pitch_offset = 0
	update_output()
	hide_menu()

func show_menu(position):
	$ActionMenu.set_position(position)
	$ActionMenu.visible = true

func hide_menu():
	$ActionMenu.visible = false

func _on_ActionMenu_cancel():
	hide_menu()

func _on_Push_performAction():
	if (time_offset < 0):
		time_offset = 0
	elif (time_offset == 0):
		time_offset = 1
	update_output()
	hide_menu()

func _on_Pull_performAction():
	if (time_offset > 0):
		time_offset = 0
	elif (time_offset == 0):
		time_offset = -1
	update_output()
	hide_menu()
