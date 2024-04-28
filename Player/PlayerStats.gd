extends Node

const MAX_LEVEL = 4
const XP_DATABASE = "res://Player/LevelDatabase.json"
var XP_Table_Data = {}
var KNOCKOUT_SPEED = 0


signal level_up
var Level : int = 1:
	set(value):
		Level = value
		%Label.text = "Level: " + str(value)
		emit_signal("level_up")
		$AnimatedSprite2D.play("level_up")
		#$AudioStreamPlayer.play()
		rpgClass.stat_growth(self)
 
var rpgClass 
 
var current_xp = 0:
	set(value):
		current_xp = value
		var max_xp = get_max_xp_at(Level)
		if current_xp >= max_xp and Level < MAX_LEVEL:
			Level += 1
			current_xp -= max_xp
		elif Level == MAX_LEVEL:
			current_xp = 0
			
		var total = min( (XP_Table_Data[str(Level)]["total"] + current_xp),
						 XP_Table_Data[str(MAX_LEVEL)]["total"] )
		%TotalXP.text = str(current_xp) + "/" + str(get_max_xp_at(Level))
		
		if get_max_xp_at(Level) == -1:
			%TotalXP.text = str(total) + "/" + "MAX"
			
		%ProgressBar.max_value = get_max_xp_at(Level)
		%ProgressBar.value = current_xp
		
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
 
var Vitality : int :
	set(value):
		Vitality = value
		@warning_ignore("integer_division") 
		HP += 10 * (Vitality/4)
		@warning_ignore("integer_division") 
		max_HP += 10 * (Vitality/4)
		%Vitality.text = str(value)
 
var Agility : int :
	set(value):
		Agility = value
		%Agility.text = str(value)
 
var Defense : int :
	set(value):
		Defense = value
		%Defense.text = str(value)
 
func _ready():
	XP_Table_Data = get_xp_data()
	rpgClass = Warrior.new()
	rpgClass.set_base_stat(self)

func get_xp_data() -> Dictionary:
	var file = FileAccess.open(XP_DATABASE, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
 
func get_max_xp_at(level):
	return XP_Table_Data[str(level)]["need"]
 
func _on_gain_xp_pressed():
	current_xp += 100
