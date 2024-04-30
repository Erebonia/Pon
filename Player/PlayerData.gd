extends Resource
class_name PlayerData

@export var level: int
@export var EXP: int
@export var HP: int
@export var max_HP: int
@export var damage: int
@export var strength: int
@export var magic: int
@export var agility: int
@export var defense: int
@export var slots: Array[InventorySlot] = []

@export var savedPosition: Vector2

func updateInventory(value: Array[InventorySlot]):
	slots = value.duplicate()

func loadSavedPosition(value: Vector2):
	savedPosition = value
	
func updateHP(value: int):
	HP = value
	
func updateMaxHP(value: int):
	max_HP = value
	
func updateLevel(value: int):
	level = value
	
func updateDMG(value: int):
	damage = value
	
func updateEXP(value: int):
	EXP = value
	
func updateSTR(value: int):
	strength = value
	
func updateMAG(value: int):
	magic = value
	
func updateAGI(value: int):
	agility = value
	
func updateDEF(value: int):
	defense = value

