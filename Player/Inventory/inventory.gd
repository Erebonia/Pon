extends Resource
class_name Inventory

signal updated
signal use_item
signal inventory_full

#Inventory stored here. TODO save it to player and load it later.
@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty() and itemSlots[0].amount + 1 <= item.maxAmountPrStack:
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emit_signal("inventory_full", false)
			emptySlots[0].item = item
			emptySlots[0].amount = 1
		else:
			emit_signal("inventory_full", true)
			print("FULL")
			return
			
	updated.emit()

func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	
	remove_at_index(index)
	
func remove_at_index(index: int) -> void:
	slots[index] = InventorySlot.new()
	updated.emit()
	
func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	updated.emit()

func use_item_at_index(index: int) -> void:
	if index < 0 or index >= slots.size() or !slots[index].item or !slots[index].item.isConsumable: return
	
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -=1
		updated.emit()
		return
	
	remove_at_index(index)
