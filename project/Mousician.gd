extends Area2D

export(AudioStream) var intro_track
export(AudioStream) var loop_track

const SADNESS_CHANCE_PER_SECOND = 0.1
var rng = RandomNumberGenerator.new()

var pitch_offset = 0
var time_offset = 0
var touch_start

func _ready():
	rng.randomize()

func _process(delta):
	if ((!is_sad()) && (rng.randf() < (SADNESS_CHANCE_PER_SECOND * delta))):
		become_sad()

func _input_event(camera, event, shape):
	if (event is InputEventScreenTouch):
		if (event.index == 0 && is_sad()):
			if (event.pressed):
				touch_start = event.position
			else:
				var touch_vector = event.position - touch_start
				if (touch_vector.normalized().dot(Vector2(0, pitch_offset)) > 0):
					pitch_offset = 0
					update_output()

func is_sad():
	return time_offset != 0 || pitch_offset != 0

func play_loop():
	$AudioStreamPlayer.stream = loop_track
	$AudioStreamPlayer.play()

func become_sad():
	if (rng.randf() > 0.5):
		pitch_offset = 1
	else:
		pitch_offset = -1
	update_output()

func update_output():
	match pitch_offset:
		0:
			$AnimatedSprite.play("default")
			$AudioStreamPlayer.bus = "Master"
		-1:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Flat"
		1:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Sharp"
