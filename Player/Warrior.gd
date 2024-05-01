extends Resource
class_name Warrior
 
var HP : int
var max_HP : int
var Strength : int
var Magic : int
var Agility : int
var Defense : int
 
func _init():
	HP = 10
	max_HP = HP
	Strength = 7
	Magic = 4
	Agility = 2
	Defense = 3
 
func set_base_stat(target):
	target.HP = HP
	target.max_HP = max_HP
	target.Strength = Strength
	target.Magic = Magic
	target.Agility = Agility
	target.Defense = Defense
 
func stat_growth(target):
	target.HP += 10
	target.max_HP += 10
	target.Strength += 4
	target.Magic += 2
	target.Agility += 1
	target.Defense += 2
