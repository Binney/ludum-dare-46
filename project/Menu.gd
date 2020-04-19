extends Node2D

var player_state

func _ready():
	player_state = get_tree().get_root().get_child(0)

func _on_Level_1_Btn_pressed():
	player_state.set_level(1)
	get_tree().change_scene("res://LevelOne.tscn")

func _on_Level_2_Btn_pressed():
	player_state.set_level(2)
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
