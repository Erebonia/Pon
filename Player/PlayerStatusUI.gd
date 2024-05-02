extends Control

class_name PlayerStatusUI

func _ready():
	Status.connect("update_stats", Callable(self, "_update_stats_ui"))
	Status.connect("level_up", Callable(self, "_update_level_ui"))
	Status.connect("experience_gained", Callable(self, "_update_xp_ui"))
	
func _process(delta):
	_update_stats_ui(Status.HP, Status.max_HP, Status.Strength, Status.Magic, Status.Agility, Status.Defense)
	_update_level_ui(Status.Level)
	_update_xp_ui(Status.experience_gained, Status.current_xp, Status.get_required_experience(Status.Level))

func _update_stats_ui(hp, max_hp, strength, magic, agility, defense):
	%HP.text = str(hp) + "/" + str(max_hp)
	%Strength.text = str(strength)
	%Magic.text = str(magic)
	%Agility.text = str(agility)
	%Defense.text = str(defense)

func _update_level_ui(level):
	%Level.text = "Level: " + str(level)

func _update_xp_ui(exp_gained, total_exp, next_level_exp):
	%ProgressBar.max_value = next_level_exp
	%ProgressBar.value = total_exp
	if next_level_exp == -1:
		next_level_exp = "MAX"
	%TotalXP.text = str(total_exp) + "/" + str(next_level_exp)
