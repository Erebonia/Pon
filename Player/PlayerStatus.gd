extends Node

const MAX_LEVEL = 4
var XP_Table_Data = {}
var current_xp = 0
var Level : int = 1: set = set_level
var HP : int : set = set_hp
var max_HP : int : set = set_max_hp
var Strength : int
var Magic : int
var Agility : int
var Defense : int
var KNOCKOUT_SPEED = 0
var dungeonFloor: int = 0

# Define new signals
signal level_up(Level)
signal experience_gained(exp_gained, total_exp, next_level_exp)
signal no_HP
signal update_stats(HP, max_HP, Strength, Magic, Agility, Defense)

# RPG Class for handling stats growth
var rpgClass

func _ready():
	load_xp_data()
	rpgClass = Warrior.new()
	rpgClass.set_base_stat(self)
	update_ui()

func gain_experience(amount):
	if Level >= MAX_LEVEL:
		return
	current_xp += amount
	check_level_up()
	emit_signal("experience_gained", current_xp, get_required_experience(Level))
	update_ui()

func check_level_up():
	while current_xp >= get_required_experience(Level) and Level < MAX_LEVEL:
		current_xp -= get_required_experience(Level)
		set_level(Level + 1)
		rpgClass.stat_growth(self)

func set_level(value):
	if value != Level and value <= MAX_LEVEL:
		Level = value
		emit_signal("level_up", Level)

func set_hp(value):
	HP = value
	if HP <= 0:
		emit_signal("no_HP")
	emit_signal("update_stats", HP, max_HP, Strength, Magic, Agility, Defense)

func set_max_hp(value):
	max_HP = value
	emit_signal("update_stats", HP, max_HP, Strength, Magic, Agility, Defense)

func get_required_experience(level):
	return XP_Table_Data[str(level)]["need"]

func load_xp_data():
	var file = FileAccess.open("res://Player/LevelDatabase.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	XP_Table_Data = data

func update_ui():
	emit_signal("update_stats", HP, max_HP, Strength, Magic, Agility, Defense)
