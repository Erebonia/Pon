extends CanvasLayer

class_name UserInterface

@onready var inventory = $InventoryGui
@onready var hotbar = $Hotbar
@onready var playerStatusUI = $"Status Screen"

func _ready():
	inventory.close()
	playerStatusUI.visible = false
	hotbar.visible = true
	
func _input(_event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory.isOpen:
			AudioManager.get_node("Close_Inventory").play()
			inventory.close()
			playerStatusUI.visible = false
		else:
			AudioManager.get_node("Open_Inventory").play()
			inventory.open()
			playerStatusUI.visible = true
			
