extends Resource
class_name Warrior
 
var HP : int
var max_HP : int
var Strength : int
var Magic : int
var Agility : int
var Defense : int
 
func _init():
	HP = 90
	max_HP = HP
	Strength = 7
	Magic = 7
	Agility = 7
	Defense = 7
 
func set_base_stat(target):
	target.HP = HP
	target.max_HP = max_HP
	target.Strength = Strength
	target.Magic = Magic
	target.Agility = Agility
	target.Defense = Defense
 
func stat_growth(target):
	target.HP += 20
	target.max_HP += 20
	target.Strength += 4
	target.Magic += 4
	target.Agility += 1
	target.Defense += 5
