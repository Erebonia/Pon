extends Panel

class_name Hotbar

@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

@export var currently_selected: int = 0
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("updateInventoryUI", Callable(self, "update"))
	inventory.updated.connect(update)
	update()

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)
			
func move_selector() -> void:
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	
func move_selector_backwards() -> void:
	currently_selected = (currently_selected - 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event) -> void:
	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_selected)
	if event.is_action_pressed("move_selector"):
		move_selector()
	elif event.is_action_pressed("move_selector_reverse"):
		move_selector_backwards()
