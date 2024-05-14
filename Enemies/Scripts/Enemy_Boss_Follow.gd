extends Enemy_Follow

@onready var homingMissile = $"../HomingMissile"
@onready var laserBeam = $"../LaserBeam"

func Enter():
	animation_player.play("idle")

func Physics(delta : float) -> EnemyState:
	
	if player != null:
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
		accelerate_towards_point(player.global_position, delta)
		
	if enemy.direction.length() > 9 and enemy.direction.length() < 20:
		attackPlayerRanged()
		
	if enemy.direction.length() <= 9:
		return melee
		
	enemy.move_and_slide()
	return null
	
func attackPlayerRanged():
	var chance = randi() % 2
	match chance:
		0:
			state_machine.ChangeState(homingMissile)
		1:
			state_machine.ChangeState(laserBeam)
