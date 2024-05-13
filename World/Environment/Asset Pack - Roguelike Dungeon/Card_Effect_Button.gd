extends Button

func _on_mouse_entered():
	modulate = Color(3,3,3)
	
func _on_mouse_exited():
	modulate = Color(1,1,1)

func _on_pressed():
	var card_selection = get_tree().get_first_node_in_group("CardSelection")
	match find_child("Card_Title").text:
		"Gladiator":
			Status.tempSTR = card_selection.strength
			Status.Strength = Status.Strength + Status.tempSTR
		"Fortify":
			Status.tempDEF = card_selection.defense
			Status.Defense = Status.Defense + Status.tempDEF
		"Flash":
			Status.tempAGI = card_selection.agility
			Status.Agility = Status.Agility + Status.tempAGI
	card_selection.visible = false
	get_tree().paused = false
