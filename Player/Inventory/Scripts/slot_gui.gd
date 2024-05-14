extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

@onready var inventory = preload("res://Player/Inventory/PlayerInventory.tres")

var itemStackGui: ItemStackGui
var index: int

func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
	
	if !itemStackGui.inventory_slot or inventory.slots[index] == itemStackGui.inventory_slot:
		return
		
	inventory.insertSlot(index, itemStackGui.inventory_slot)
	
func takeItem():
	var item = itemStackGui
	
	inventory.removeSlot(itemStackGui.inventory_slot)
	
	return item
	
func isEmpty():
	return !itemStackGui
	
func clear() -> void:
	if itemStackGui:
		container.remove_child(itemStackGui)
		itemStackGui = null
		
	backgroundSprite.frame = 0
