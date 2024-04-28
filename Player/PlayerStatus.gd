extends Node

const MAX_LEVEL = 4
var XP_Table_Data = {}

# Define new signals
signal level_up
signal experience_gained(exp_gained, total_exp, next_level_exp)

# RPG Class for handling stats growth
var rpgClass

#General
var KNOCKOUT_SPEED = 0

var current_xp = 0
func gain_experience(amount):
	if Level >= MAX_LEVEL:
		return
	current_xp += amount
	check_level_up()
	emit_signal("experience_gained", amount, current_xp, get_required_experience(Level))

func check_level_up():
	while current_xp >= get_required_experience(Level) and Level < MAX_LEVEL:
		current_xp -= get_required_experience(Level)
		set_level(Level + 1)
		emit_signal("level_up")
		$AnimatedSprite2D.play("level_up")
		#$AudioStreamPlayer.play()
		rpgClass.stat_growth(self)

func get_required_experience(level):
	return XP_Table_Data[str(level)]["need"]

var Level : int = 1: set = set_level
func set_level(value):
	if value != Level and value <= MAX_LEVEL:
		Level = value
		%Label.text = "Level: " + str(Level)

signal no_HP
var HP : int :
	set(value):
		HP = value
		if HP <= 0:
			emit_signal("no_HP")
		%HP.text = str(HP) + "/" + str(max_HP)
		
var max_HP : int :
	set(value):
		max_HP = value
		%HP.text = str(HP) + "/" + str(max_HP)
	
var Strength : int :
	set(value):
		Strength = value
		%Strength.text = str(value)
 
var Magic : int :
	set(value):
		Magic = value
		%Magic.text = str(value)
 
var Agility : int :
	set(value):
		Agility = value
		%Agility.text = str(value)
 
var Defense : int :
	set(value):
		Defense = value
		%Defense.text = str(value)

func _ready():
	load_xp_data()
	rpgClass = Warrior.new()
	rpgClass.set_base_stat(self)
	
func _process(_delta):
	#Update the progress bar realtime since the setter doesn't account for player loading.
	%ProgressBar.max_value = get_required_experience(Level)
	%ProgressBar.value = current_xp
	%TotalXP.text = str(current_xp) + "/" + str(get_required_experience(Level))
	if get_required_experience(Level) == -1:
		%TotalXP.text = "MAX"

func load_xp_data():
	var file = FileAccess.open("res://Player/LevelDatabase.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	XP_Table_Data = data

# Example usage when gaining XP from an action
func _on_gain_xp_pressed():
	gain_experience(50)  # Gain 50 XP
	
