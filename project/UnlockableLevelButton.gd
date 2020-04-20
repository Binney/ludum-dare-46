extends Button

export(int) var unlocked_at_cheeses = 0

func _ready():
	var player_state = get_tree().get_root().get_child(0)
	var overall_score = 0
	for i in range(2): # qq number of levels
		overall_score += player_state.cheese_array[i]
	if overall_score>=unlocked_at_cheeses:
		
		disabled = false

