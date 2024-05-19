extends State
class_name State_Idle

@onready var run : Node2D = $"../Run"
@onready var idle : Node2D = $"../Idle"
@onready var evade : Node2D = $"../Evade"
@onready var attack : Node2D = $"../Attack"
@onready var sword_stance : Node2D = $"../Sword_Stance"
@onready var inventory: Inventory = preload("res://Player/Inventory/PlayerInventory.tres")

func Enter():
	player.UpdateAnimation("Idle")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	super.Process(_delta)
	return null
	
func Physics(_delta : float) -> State:
	
	if Input.is_action_pressed("Sword Wave (Activate)") and player.weapon_equipped:
		return sword_stance
	
	if Input.is_action_pressed("attack") and player.weapon_equipped:
		return attack
		
	if Input.is_action_just_pressed("evade"):
		return evade
	
	if player.input_vector != Vector2.ZERO:
		return run
		 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null


