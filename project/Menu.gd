extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Level_1_Btn_pressed():
	 get_tree().change_scene("res://LevelOne.tscn")


func _on_Level_2_Btn_pressed():
	 get_tree().change_scene("res://LevelTwo.tscn")


func _on_Tutorial_1_Btn_pressed():
	 get_tree().change_scene("res://TutorialOne.tscn")


func _on_Tutorial_2_Btn_pressed():
	 get_tree().change_scene("res://TutorialTwo.tscn")


func _on_Tutorial_3_Btn_pressed():
	 get_tree().change_scene("res://TutorialThree.tscn")


func _on_Bonus_level_Btn_pressed():
	 get_tree().change_scene("res://BonusLevel.tscn")


func _on_Level_1_Btn_dubstep_pressed():
	 get_tree().change_scene("res://LevelOneDubstep.tscn")
