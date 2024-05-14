extends Button

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _on_mouse_entered():
	modulate = Color(3,3,3)
	
func _on_mouse_exited():
	modulate = Color(1,1,1)

func _on_pressed():
	var card_selection = get_tree().get_first_node_in_group("CardSelection")
	match find_child("Card_Title").text:
		"Gladiator":
			player.player_data.temp_str = card_selection.strength
			player.player_data.Strength = player.player_data.Strength + player.player_data.temp_str
		"Fortify":
			player.player_data.temp_def = card_selection.defense
			player.player_data.Defense = player.player_data.Defense + player.player_data.temp_def
		"Flash":
			player.player_data.temp_agi = card_selection.agility
			player.player_data.Agility = player.player_data.Agility + player.player_data.temp_agi
	card_selection.visible = false
	get_tree().paused = false
