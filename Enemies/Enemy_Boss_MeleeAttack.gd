extends EnemyState

@onready var follow = $"../Follow"
@onready var dash = $"../Dash"
 
var can_transition: bool = false

func Enter():
	animation_player.speed_scale = 1.5
	animation_player.play("melee_attack")
	await animation_player.animation_finished
	animation_player.speed_scale = 1
 
func Exit():
	can_transition = false
	
func Physics(_delta : float) -> EnemyState:
	print(can_transition)
	if owner.direction.length() > 50:
		return dash 
	
	return null

