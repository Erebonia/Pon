extends Control

class_name PlayerStatusUI

@onready var player : Player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	_update_stats_ui(player.playerData.HP, player.playerData.max_HP, player.playerData.Strength, player.playerData.Magic, player.playerData.Agility, player.playerData.Defense)
	_update_level_ui(player.playerData.Level)
	_update_xp_ui(player.playerData.current_xp, player.playerData.get_required_experience(player.playerData.Level))

func _update_stats_ui(hp, max_hp, strength, magic, agility, defense):
	%HP.text = str(hp) + "/" + str(max_hp)
	%Strength.text = str(strength)
	%Magic.text = str(magic)
	%Agility.text = str(agility)
	%Defense.text = str(defense)

func _update_level_ui(level):
	%Level.text = "Level: " + str(level)

func _update_xp_ui(total_exp, next_level_exp):
	%ProgressBar.max_value = next_level_exp
	%ProgressBar.value = total_exp
	if next_level_exp == -1:
		%TotalXP.text = str("MAX")
	else:
		%TotalXP.text = str(total_exp) + "/" + str(next_level_exp)
