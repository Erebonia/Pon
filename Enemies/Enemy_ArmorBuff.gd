extends EnemyState
 
var can_transition : bool = false
@onready var follow = $"../Follow"

func Enter():
	animation_player.play("armor_buff")
	await animation_player.animation_finished
	can_transition = true
	
func Exit():
	pass
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		return follow
		
	return null
