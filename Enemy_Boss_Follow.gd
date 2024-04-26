extends Enemy_Follow

func Enter():
	animation_player.play("idle")

func Physics(_delta : float) -> EnemyState:
	var distance = owner.direction.length()
	
	if distance > 50:
		attackPlayerRanged()
		pass
	else:
		return melee
		
	return null
	
func attackPlayerRanged():
	var chance = randi() % 2
	match chance:
		0:
			StateMachine.ChangeState(homingMissile)
		1:
			StateMachine.ChangeState(laserBeam)
