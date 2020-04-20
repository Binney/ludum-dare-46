extends Node2D

var player_state
const MENU_MOUSE_SPEED = 50
const ANIMATION_NAMES = ["KeyboardMouse", "FluteMouse", "SnareMouse", "GuitarMouse", "TubaMouse"]
var rng = RandomNumberGenerator.new()

func _ready():
	player_state = get_tree().get_root().get_child(0)
	randomise_mouse()

func _process(delta):
	$MenuMouse.position.x += MENU_MOUSE_SPEED * delta

func _on_VisibilityNotifier2D_screen_exited():
	$MenuMouse.position.x = -160
	randomise_mouse()

func randomise_mouse():
	var random_animation = ANIMATION_NAMES[rng.randi_range(0, 4)]
	$MenuMouse/AnimatedSprite.frames = load("res://sprite/" + random_animation + ".tres")

func _on_Level1_button_pressed():
	player_state.set_level(1)
	get_tree().change_scene("res://TutorialOne.tscn")

func _on_Level2_button_pressed():
	player_state.set_level(2)
	get_tree().change_scene("res://TutorialTwo.tscn")

func _on_Level3_button_pressed():
	player_state.set_level(3)
	get_tree().change_scene("res://TutorialThree.tscn")

func _on_Level4_button_pressed():
	player_state.set_level(4)
	get_tree().change_scene("res://LevelOne.tscn")

func _on_Level5_button_pressed():
	player_state.set_level(5)
	get_tree().change_scene("res://LevelTwo.tscn")

func _on_BonusLevel_button_pressed():
	get_tree().change_scene("res://BonusLevel.tscn")
