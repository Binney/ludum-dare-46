extends Area2D

export(AudioStream) var intro_track
export(AudioStream) var loop_track
export(SpriteFrames) var frames setget set_frames
export var is_percussion = false
export var is_always_happy = false

const SADNESS_CHANCE_PER_SECOND = 0.1
const SADNESS_COOL_OFF_TIME_MS = 5000
const SADNESS_EXCLAMATION_DELAY_MS = 3000
var rng = RandomNumberGenerator.new()

var pitch_offset = 0
var time_offset = 0
const pitch_offset_max = 3
var track_start_time
var cool_off_start_time = -SADNESS_COOL_OFF_TIME_MS
var sadness_start_time = 0

var is_intro = true

var busId
var pitchShiftEffect

func _ready():
	rng.randomize()
	$Exclamation.visible = false
	$AnimatedSprite.frames = frames
	$AnimatedSprite.play("happy")
	setUpBus()
	if (intro_track == null):
		play_loop()
	else:
		play_intro()

func set_frames(new_frames):
	frames = new_frames
	$AnimatedSprite.frames = new_frames	

func setUpBus():
	busId = AudioServer.bus_count
	AudioServer.add_bus(busId)
	var busName = "mouse-" + str(busId)
	AudioServer.set_bus_name(busId, busName)
	$AudioStreamPlayer.set_bus(busName)
	pitchShiftEffect = AudioEffectPitchShift.new()
	AudioServer.add_bus_effect(busId, pitchShiftEffect)

func _process(delta):
	if (!is_always_happy && !is_intro && !is_cooling_off() && !is_sad() && (rng.randf() < (SADNESS_CHANCE_PER_SECOND * delta))):
		become_sad()
	
	if (is_sad() && (OS.get_ticks_msec() - sadness_start_time) > SADNESS_EXCLAMATION_DELAY_MS):
		$Exclamation.visible = true
		
	if (is_percussion && time_offset != 0):
		$AudioStreamPlayer.pitch_scale += (time_offset * delta / 50)

func is_sad():
	return time_offset != 0 || pitch_offset != 0

func is_cooling_off():
	return OS.get_ticks_msec() - cool_off_start_time < SADNESS_COOL_OFF_TIME_MS

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
	if is_sad():
		$AnimatedSprite.play("sad")
		# Don't make the exclamation visible here because that happens after a delay (done in _process())
		sadness_start_time = OS.get_ticks_msec()
	else:
		$AnimatedSprite.play("happy")
		$Exclamation.visible = false
		cool_off_start_time = OS.get_ticks_msec()
		
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

func handleAction(action):
	match (action):
		'sharpen':
			if (pitch_offset < pitch_offset_max):
				pitch_offset += 1
		'flatten':
			if (pitch_offset > -pitch_offset_max):
				pitch_offset -= 1
		'push':
			if (time_offset < 0):
				time_offset = 0
			elif (time_offset == 0):
				time_offset = 1
		'pull':
			if (time_offset > 0):
				time_offset = 0
			elif (time_offset == 0):
				time_offset = -1
	update_output()

func _on_AudioStreamPlayer_finished():
	if(is_intro):
		play_loop()
