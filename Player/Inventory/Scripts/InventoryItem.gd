extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPrStack: int
@export var isConsumable: bool = false
@export var isWeapon: bool = false
@export var isHelmet = false
@export var isBody = false
@export var isAccessory = false

func use(player: Player) -> void:
	pass
	
# In InventoryItem.gd

func getType():
	if isHelmet:
		return "Helmet"
	elif isBody:
		return "Body"
	elif isAccessory:
		return "Accessory"
	return "None"

