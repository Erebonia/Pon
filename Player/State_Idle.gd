extends State
class_name State_Idle

@onready var run = $"../Run"
@onready var roll = $"../Roll"
@onready var attack = $"../Attack"

func Enter():
	player.UpdateAnimation("Idle")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(delta : float) -> State:
	player.animationTree.set("parameters/Idle/blend_position", player.input_vector)
	
	if player.input_vector != Vector2.ZERO:
		return run
		
	if Input.is_action_just_pressed("attack"):
		return attack
		 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null
