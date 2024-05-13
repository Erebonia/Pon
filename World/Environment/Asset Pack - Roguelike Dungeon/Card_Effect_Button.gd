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
			player.stats.tempSTR = card_selection.strength
			player.stats.Strength = player.stats.Strength + player.stats.tempSTR
		"Fortify":
			player.stats.tempDEF = card_selection.defense
			player.stats.Defense = player.stats.Defense + player.stats.tempDEF
		"Flash":
			player.stats.tempAGI = card_selection.agility
			player.stats.Agility = player.stats.Agility + player.stats.tempAGI
	card_selection.visible = false
	get_tree().paused = false
