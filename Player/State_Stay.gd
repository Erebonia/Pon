extends State
class_name State_Stay

#Used for things like cutscenes or events I don't want the player to move. 
#state_machine.change_state(STATE) will bring us out of here.

func Enter():
	player.UpdateAnimation("Idle")
	
func Exit():
	pass
	
func Process(_delta : float) -> State:
	return null
	
func Physics(_delta : float) -> State: 
	#Stop Movement
	player.velocity = Vector2.ZERO
	return null
	
