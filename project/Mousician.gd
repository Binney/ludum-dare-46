extends Area2D


export(AudioStream) var intro_track
export(AudioStream) var loop_track
export var is_percussion = false

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

func _input_event(_camera, event, _shape):
	if (event is InputEventScreenTouch):
		if (event.index == 0 && is_sad()):
			if (event.pressed):
				touch_start = event.position
			elif (touch_start):
				var touch_vector = (event.position - touch_start).normalized()
				if ((pitch_offset != 0) && (touch_vector.dot(Vector2(0, pitch_offset)) > 0.75)):
					pitch_offset = 0
				if ((time_offset != 0) && (touch_vector.dot(Vector2(time_offset, 0)) < -0.75)):
					time_offset = 0
				update_output()

func is_sad():
	return time_offset != 0 || pitch_offset != 0

func play_loop():
	$AudioStreamPlayer.stream = loop_track
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
			$AnimatedSprite.play("default")
			$AudioStreamPlayer.bus = "Healthy"
		[-1, 0]:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Flat"
		[1, 0]:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Sharp"
		[0, 0]:
			$AnimatedSprite.play("default")
			$AudioStreamPlayer.bus = "Healthy"
		[0, -1]:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Slow"
		[0, 1]:
			$AnimatedSprite.play("sad")
			$AudioStreamPlayer.bus = "Fast"
