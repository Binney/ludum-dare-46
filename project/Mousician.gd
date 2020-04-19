extends Area2D

export(AudioStream) var intro_track
export(AudioStream) var loop_track
export var is_percussion = false

const SADNESS_CHANCE_PER_SECOND = 0.1
var rng = RandomNumberGenerator.new()

var pitch_offset = 0
var time_offset = 0
const pitch_offset_max = 3
var touch_start
var track_start_time

var is_intro = true

var busId
var pitchShiftEffect

func _ready():
	rng.randomize()
	$AnimatedSprite.play("happy")
	$ActionMenu/Sharpen.visible = !is_percussion
	$ActionMenu/Flatten.visible = !is_percussion
	setUpBus()
	if (intro_track == null):
		play_loop()
	else:
		play_intro()
	
func setUpBus():
	busId = AudioServer.bus_count
	AudioServer.add_bus(busId)
	var busName = "mouse-" + str(busId)
	AudioServer.set_bus_name(busId, busName)
	$AudioStreamPlayer.set_bus(busName)
	pitchShiftEffect = AudioEffectPitchShift.new()
	AudioServer.add_bus_effect(busId, pitchShiftEffect)

func _process(delta):
	if (!is_intro && (!is_sad()) && (rng.randf() < (SADNESS_CHANCE_PER_SECOND * delta))):
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
	is_intro = false
	$AudioStreamPlayer.stream = loop_track
	track_start_time = OS.get_ticks_usec()
	$AudioStreamPlayer.play()
	
func play_intro():
	$AudioStreamPlayer.stream = intro_track
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
	var is_happy = pitch_offset == 0 && time_offset == 0
	var sprite_set_name = "happy" if is_happy else "sad"
	$AnimatedSprite.play(sprite_set_name)
		
	# Time shift for drums needs to happen gradually, so is implemented in process(). As such we do not alter the time shift for percussion here.
	var effectiveTimeOffset = 0 if is_percussion else time_offset
	$AudioStreamPlayer.pitch_scale = calculate_ratio_for_offset(effectiveTimeOffset)
	pitchShiftEffect.pitch_scale = calculate_ratio_for_offset(pitch_offset - effectiveTimeOffset)
	
	# Percussion is not excluded when re-correcting on returning to no time offset
	if time_offset == 0:
		resync_track()
		
func resync_track():
	var elapsedMicroseconds = OS.get_ticks_usec() - track_start_time
	var elapsedSeconds = elapsedMicroseconds / float(1000000)
	var loopOffset = fmod(elapsedSeconds, $AudioStreamPlayer.stream.get_length())
	$AudioStreamPlayer.seek(loopOffset)

func calculate_ratio_for_offset(semitoneShift):
	return pow(2, (semitoneShift)/float(12))

func _on_Sharpen_performAction():
	if (pitch_offset < pitch_offset_max):
		pitch_offset += 1
	update_output()
	hide_menu()

func _on_Flatten_performAction():
	if (pitch_offset > -pitch_offset_max):
		pitch_offset -= 1
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

func _on_AudioStreamPlayer_finished():
	if(is_intro):
		play_loop()
