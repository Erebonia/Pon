extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPrStack: int
@export var isConsumable: bool = false
@export var isWeapon: bool = false
@export var isHelmet: bool = false
@export var isBody: bool = false
@export var isAccessory: bool = false
@export var attackBonus: int = 0
@export var defBonus: int = 0
@export var hpBonus: int = 0

func use(player: Player) -> void:
	pass
	
func getType():
	if isHelmet:
		return "Helmet"
	elif isBody:
		return "Body"
	elif isAccessory:
		return "Accessory"
	return "None"

