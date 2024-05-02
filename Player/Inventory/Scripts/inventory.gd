extends Resource
class_name Inventory

signal updated
signal use_item
signal inventory_full

#Inventory stored here. TODO save it to player and load it later.
@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	# Filter out the trash can slot when checking for empty slots
	var emptySlots = []
	for i in range(slots.size() - 4):  # Exclude the last slot (trash can)
		if slots[i].item == null:
			emptySlots.append(slots[i])

	if emptySlots.is_empty():
		emit_signal("inventory_full", true)
		print("FULL")
		return

	var itemSlots = slots.filter(func(slot): return slot.item == item and slot != slots[slots.size() - 4])
	if !itemSlots.is_empty() and itemSlots[0].amount + 1 <= item.maxAmountPrStack:
		itemSlots[0].amount += 1
	else:
		if emptySlots.size() > 0:
			emptySlots[0].item = item
			emptySlots[0].amount = 1
		else:
			emit_signal("inventory_full", true)
			print("FULL")
			return

	check_inventory_full()
	updated.emit()


func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	remove_at_index(index)
	
func remove_at_index(index: int) -> void:
	slots[index] = InventorySlot.new()
	updated.emit()
	
func remove_trash():
	# Directly clear the last slot assuming it's the trash can
	slots[slots.size() - 1].item = null
	slots[slots.size() - 1].amount = 0
	print("Trash slot emptied, item discarded.")
	check_inventory_full()
	updated.emit()

	
func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	updated.emit()
	
func check_inventory_full():
	var is_full = true
	# Check all regular slots excluding equipment and trash can slots.
	for i in range(slots.size() - 4):  # Assuming the last 4 slots are not regular item slots.
		if slots[i].item == null:
			is_full = false
			break
	emit_signal("inventory_full", is_full)



func use_item_at_index(index: int) -> void:
	if index < 0 or index >= slots.size() or !slots[index].item or !slots[index].item.isConsumable: return
	
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -=1
		updated.emit()
		return
	
	remove_at_index(index)
