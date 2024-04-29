extends CanvasLayer

@onready var inventory = $InventoryGui

func _ready():
	inventory.close()
	
func _input(event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
			
