extends State
class_name State_Idle

@onready var run = $"../Run"
@onready var roll = $"../Roll"
@onready var attack = $"../Attack"
@onready var sword_stance = $"../Sword_Stance"

func Enter():
	player.UpdateAnimation("Idle")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State:
	
	if Input.is_action_pressed("Sword Wave (Activate)"):
		return sword_stance
	
	if Input.is_action_pressed("attack"):
		return attack
		
	if Input.is_action_just_pressed("roll"):
		return roll
	
	if player.input_vector != Vector2.ZERO:
		return run
		 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null
