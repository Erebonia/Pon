extends Control

class_name Inventory_gui

var isOpen: bool = false

signal opened
signal closed

@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")
@onready var ItemStackGuiClass = preload("res://Player/Inventory/Scene/itemStackGui.tscn")
@onready var hotbar_slots: Array = $NinePatchRect/HBoxContainer.get_children()
@onready var extraSlots: Array = [$Hat_Slot, $Body_Slot, $Accessory_Slot, $Trash]
@onready var slots: Array = hotbar_slots + $NinePatchRect/GridContainer.get_children() + extraSlots
@onready var player = $"../../Player"


var itemInHand: ItemStackGui
var oldIndex: int = -1
var locked: bool = false
var trashCanIndex = 19

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	player.connect("updateInventoryUI", Callable(self, "update"))
	update()
	
func _process(delta):
	update()
	
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

signal inventory_full		
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item:
			slots[i].clear()
			continue
			
		if i == trashCanIndex:
			print("Trash detected")
			inventory.remove_trash()
			continue
			
		if i == 16 and inventorySlot.item != null:
			$Hat_Slot/background/Hat_Slot_BG.visible = false
			
		if i == 17 and inventorySlot.item != null:
			$Body_Slot/background/Body_Slot_BG.visible = false
			
		if i == 18 and inventorySlot.item != null:
			$Accessory_Slot/background/Accessory_Slot_BG.visible = false
			
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
		
func open():
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()

func onSlotClicked(slot):
	if locked:
		return

	# Check if there's an item in hand and the slot clicked corresponds to a specific type
	if itemInHand:
		if slot.index == 16 and itemInHand.inventorySlot.item.isHelmet:
			handleEquipmentSlot(slot, itemInHand)
		elif slot.index == 17 and itemInHand.inventorySlot.item.isBody:
			handleEquipmentSlot(slot, itemInHand)
		elif slot.index == 18 and itemInHand.inventorySlot.item.isAccessory:
			handleEquipmentSlot(slot, itemInHand)
		elif slot.index < 16 or slot.index > 18:
			handleNormalSlot(slot)
	elif not itemInHand and not slot.isEmpty():
		# Handle taking an item from a slot
		takeItemFromSlot(slot)

func handleEquipmentSlot(slot, itemInHand):
	# Check if the slot is empty or needs swapping
	if not slot.isEmpty():
		if slot.itemStackGui.inventorySlot.item.getType() == itemInHand.inventorySlot.item.getType():
			swapItems(slot)  # Swap if same type
		else:
			print("Cannot swap: Item types do not match.")
	else:
		insertItemInSlot(slot)

func handleNormalSlot(slot):
	# Standard handling for non-equipment slots
	if slot.isEmpty():
		insertItemInSlot(slot)
	else:
		if not itemInHand:
			takeItemFromSlot(slot)
		elif slot.itemStackGui.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
			stackItems(slot)
		else:
			swapItems(slot)

func insertItemInSlot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	oldIndex = -1
	
	# Apply stat changes based on the type of slot
	if slot.index == 16:  # Assuming 16 is the helmet slot
		$Hat_Slot/background/Hat_Slot_BG.visible = false
		Status.Defense += item.inventorySlot.item.defBonus
	elif slot.index == 17:  # Body slot
		$Body_Slot/background/Body_Slot_BG.visible = false
		Status.HP += item.inventorySlot.item.hpBonus
		Status.max_HP += item.inventorySlot.item.hpBonus
	elif slot.index == 18:  # Accessory slot
		$Accessory_Slot/background/Accessory_Slot_BG.visible = false
		Status.Strength += item.inventorySlot.item.attackBonus
		
	inventory.check_inventory_full()

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	oldIndex = slot.index
	
	# Apply stat changes based on the type of slot
	if slot.index == 16:  # Assuming 16 is the helmet slot
		$Hat_Slot/background/Hat_Slot_BG.visible = true
		Status.Defense -= itemInHand.inventorySlot.item.defBonus
	elif slot.index == 17:  # Body slot
		$Body_Slot/background/Body_Slot_BG.visible = true
		Status.HP -= itemInHand.inventorySlot.item.hpBonus
		Status.max_HP -= itemInHand.inventorySlot.item.hpBonus
	elif slot.index == 18:  # Accessory slot
		$Accessory_Slot/background/Accessory_Slot_BG.visible = true
		Status.Strength -= itemInHand.inventorySlot.item.attackBonus
	inventory.check_inventory_full()
	
func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

func stackItems(slot):
	var slotItem: ItemStackGui = slot.itemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountPrStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount
	
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
		
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
		oldIndex = -1
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
		
	slotItem.update()
	if itemInHand: itemInHand.update()
	
func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2
	
func putItemBack():
	locked = true
	if oldIndex < 0:
		var emptySlots = slots.filter(func (s): return s.isEmpty())
		if emptySlots.is_empty(): return
		
		oldIndex = emptySlots[0].index
		
	var targetSlot = slots[oldIndex]
	
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size / 2
	tween.tween_property(itemInHand, "global_position", targetPosition, 0.2)
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false
	
func _input(event):
	if itemInHand and !locked and Input.is_action_just_pressed("rightClick"):
		putItemBack()
	
	updateItemInHand()
