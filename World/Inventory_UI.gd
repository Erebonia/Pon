extends CanvasLayer

@onready var inventory = $InventoryGui
@onready var hotbar = $Hotbar

func _ready():
	inventory.close()
	hotbar.visible = true
	
func _input(event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
			
