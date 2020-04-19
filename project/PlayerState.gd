extends Node

var last_level_score
var level_index

func set_level(number):
	level_index = number - 1

func set_level_score(percent):
	last_level_score = percent
	if percent > 70:
		cheese_array[level_index] = 3
	elif percent > 40:
		cheese_array[level_index] = max(2, cheese_array[level_index])
	else:
		cheese_array[level_index] = max(1, cheese_array[level_index])

var cheese_array = [0,0]
