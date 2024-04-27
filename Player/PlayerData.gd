extends Resource
class_name PlayerData

@export var HP: int
@export var max_HP: int
@export var damage: int
@export var level: int
@export var EXP: int
@export var savedPosition: Vector2


func loadSavedPosition(value: Vector2):
	savedPosition = value
	
func updateHP(value: int):
	HP = value
	
func updateMaxHP(value: int):
	max_HP = value
	
func updateLevel(value: int):
	level = value
	
func updateEXP(value: int):
	EXP = value
	
func updateDMG(value: int):
	damage = value
