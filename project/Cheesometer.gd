extends Node2D

export(int) var level_index

var cheese_texture = load('res://sprite/cheese.png')

func _ready():
	var player_state = get_tree().get_root().get_child(0)
	for i in range(player_state.cheese_array[level_index]):
		get_child(i).set_texture(cheese_texture)
