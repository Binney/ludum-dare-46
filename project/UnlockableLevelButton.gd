extends Button

export(int) var unlocked_at_cheeses = 0

func _ready():
	var player_state = get_tree().get_root().get_child(0)
	if player_state.get_total_score()>=unlocked_at_cheeses:
		disabled = false

