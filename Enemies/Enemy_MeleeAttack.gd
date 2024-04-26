extends EnemyState

@onready var follow = $"../Follow"
@onready var idle = $"../Idle"
 
func Enter():
	animation_player.play("melee_attack")
	await animation_player.animation_finished
 
func Exit():
	pass
	
func Physics(_delta : float) -> EnemyState:
	if owner.direction.length() > 10:
		return idle 
	
	return null
