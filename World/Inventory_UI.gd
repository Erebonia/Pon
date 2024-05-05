extends CanvasLayer

@onready var inventory = $InventoryGui
@onready var hotbar = $Hotbar
@onready var playerStatusUI = $"Status Screen"
@onready var closeSoundFX = $CloseInventory
@onready var openSoundFX = $OpenInventory

func _ready():
	inventory.close()
	playerStatusUI.visible = false
	hotbar.visible = true
	
func _input(_event):
	if Input.is_action_just_pressed("Inventory"):
		if inventory.isOpen:
			closeSoundFX.play()
			inventory.close()
			playerStatusUI.visible = false
		else:
			openSoundFX.play()
			inventory.open()
			playerStatusUI.visible = true
			
