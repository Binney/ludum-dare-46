extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = 'Level complete! You scored %d percent' % get_tree().get_root().get_child(0).last_level_score


func _on_Menu_Btn_pressed():
	get_tree().change_scene("res://Menu.tscn")
