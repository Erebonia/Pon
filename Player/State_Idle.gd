extends State
class_name State_Idle

@onready var run = $"../Run"
@onready var idle = $"../Idle"
@onready var roll = $"../Roll"
@onready var attack = $"../Attack"
@onready var sword_stance = $"../Sword_Stance"
@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")
@export var checkWep : int = 0
var weaponEquipped : bool = false

func Enter():
	player.UpdateAnimation("Idle")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	checkSelectedWeapon()
	return null
	
func Physics(_delta : float) -> State:
	
	if Input.is_action_pressed("Sword Wave (Activate)"):
		return sword_stance
	
	if Input.is_action_pressed("attack") and weaponEquipped:
		return attack
		
	if Input.is_action_just_pressed("roll"):
		return roll
	
	if player.input_vector != Vector2.ZERO:
		return run
		 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null

func checkSelectedWeapon():
	var hotbar_instance = get_parent().get_parent().get_parent().find_child("Hotbar")  # Replace with the actual path to your Hotbar node
	var currently_selected_index = hotbar_instance.currently_selected
	
	if currently_selected_index < hotbar_instance.inventory.slots.size():
		var inventory_slot = hotbar_instance.inventory.slots[currently_selected_index]
		
		if inventory_slot.item.isWeapon:
			print(inventory_slot.item.name)
			weaponEquipped = true
			print("Currently selected item is a weapon")
		else:
			print(inventory_slot.item.name)
			weaponEquipped = false
			print("Currently selected item is not a weapon")
	else:
		print("No item selected in the hotbar")

# Call this function whenever you need to check the currently selected item

