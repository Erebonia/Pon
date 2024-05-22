extends Area2D

@export var itemRes: InventoryItem

func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
