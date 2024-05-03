extends Node2D
class_name State

@onready var player : Player = get_node("../../../Player")
@onready var StateMachine = $".."
var weaponEquipped : bool = false
@onready var handSprite: Sprite2D = $"../../Combat/Sword/SwordSprite"

func _ready():
	pass

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass
	
func Process(_delta : float) -> State:
	checkSelectedWeapon()
	return null
	
func Physics( _delta : float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
	
func checkSelectedWeapon():
	var hotbar_instance = get_parent().get_parent().get_parent().find_child("Hotbar")  # Replace with the actual path to your Hotbar node
	var currently_selected_index = hotbar_instance.currently_selected
	
	if currently_selected_index < hotbar_instance.inventory.slots.size():
		var inventory_slot = hotbar_instance.inventory.slots[currently_selected_index]
		
		if inventory_slot.item != null:
			#Set the item texture and equip weapon status
			if inventory_slot.item.isWeapon: weaponEquipped = true
			else: weaponEquipped = false
			handSprite.texture = inventory_slot.item.texture
		else:
			handSprite.texture = null
		

