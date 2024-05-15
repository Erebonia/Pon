extends Control

class_name Player_Status_UI

@onready var player : Player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	update_stats_ui(player.player_data.HP, player.player_data.max_HP, player.player_data.Strength, player.player_data.Magic, player.player_data.Agility, player.player_data.Defense)
	update_level_ui(player.player_data.Level)
	update_xp_ui(player.player_data.current_xp, player.player_data.get_required_experience(player.player_data.Level))

func update_stats_ui(hp, max_hp, strength, magic, agility, defense):
	%HP.text = str(hp) + "/" + str(max_hp)
	%Strength.text = str(strength)
	%Magic.text = str(magic)
	%Agility.text = str(agility)
	%Defense.text = str(defense)

func update_level_ui(level):
	%Level.text = "Level: " + str(level)

func update_xp_ui(total_exp, next_level_exp):
	%ProgressBar.max_value = next_level_exp
	%ProgressBar.value = total_exp
	if next_level_exp == -1:
		%TotalXP.text = str("MAX")
	else:
		%TotalXP.text = str(total_exp) + "/" + str(next_level_exp)
