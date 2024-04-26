extends Enemy_MeleeAttack

func Enter():
	animation_player.speed_scale = 1.5
	animation_player.play("melee_attack")
	await animation_player.animation_finished
	animation_player.speed_scale = 1
	
func Physics(_delta : float) -> EnemyState:
	if owner.direction.length() > 50:
		return dash 
	
	return null

