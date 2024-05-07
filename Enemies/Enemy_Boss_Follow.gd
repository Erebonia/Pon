extends Enemy_Follow

@onready var homingMissile = $"../HomingMissile"
@onready var laserBeam = $"../LaserBeam"

func Enter():
	animation_player.play("idle")

func Physics(delta : float) -> EnemyState:
	var distance = owner.direction.length()
	
	if distance > 50 and distance < 100:
		attackPlayerRanged()
	elif distance < 5:
		return melee
		
	return null
	
func attackPlayerRanged():
	var chance = randi() % 2
	match chance:
		0:
			StateMachine.ChangeState(homingMissile)
		1:
			StateMachine.ChangeState(laserBeam)
			
