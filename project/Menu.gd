extends Node2D

var player_state
const MENU_MOUSE_SPEED = 50

func _ready():
	player_state = get_tree().get_root().get_child(0)
	$MenuMouse.randomise()

func _process(delta):
	$MenuMouse.position.x += MENU_MOUSE_SPEED * delta

func _on_VisibilityNotifier2D_screen_exited():
	$MenuMouse.position.x = -160
	$MenuMouse.randomise()

func _on_Level1_button_pressed():
	player_state.set_level(1)
	get_tree().change_scene("res://level/01.tscn")

func _on_Level2_button_pressed():
	player_state.set_level(2)
	get_tree().change_scene("res://level/02.tscn")

func _on_Level3_button_pressed():
	player_state.set_level(3)
	get_tree().change_scene("res://level/03.tscn")

func _on_Level4_button_pressed():
	player_state.set_level(4)
	get_tree().change_scene("res://level/04.tscn")

func _on_Level5_button_pressed():
	player_state.set_level(5)
	get_tree().change_scene("res://level/05.tscn")

func _on_BonusLevel_button_pressed():
	get_tree().change_scene("res://level/Bonus.tscn")
