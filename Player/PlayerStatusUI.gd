extends Control

class_name PlayerStatusUI

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.stats.connect("update_stats", Callable(self, "_update_stats_ui"))
	player.stats.connect("level_up", Callable(self, "_update_level_ui"))
	player.stats.connect("experience_gained", Callable(self, "_update_xp_ui"))
	
func _process(_delta):
	_update_stats_ui(player.stats.HP, player.stats.max_HP, player.stats.Strength, player.stats.Magic, player.stats.Agility, player.stats.Defense)
	_update_level_ui(player.stats.Level)
	_update_xp_ui(player.stats.current_xp, player.stats.get_required_experience(player.stats.Level))

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
