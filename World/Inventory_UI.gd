extends CanvasLayer

@onready var inventory = $InventoryGui
@onready var hotbar = $Hotbar
@onready var playerStatusUI = $"Status Screen"

func _ready():
	inventory.close()
	playerStatusUI.visible = false
	hotbar.visible = true
	
func _input(event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory.isOpen:
			inventory.close()
			playerStatusUI.visible = false
		else:
			inventory.open()
			playerStatusUI.visible = true
			
