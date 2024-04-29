extends Resource

class_name InventoryItem

@export var name: String = ""
@export var texture: Texture2D
@export var maxAmountPrStack: int
@export var isConsumable: bool = false

func use(player: Player) -> void:
	pass
