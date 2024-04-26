extends EnemyState

@onready var follow = $"../Follow"
@onready var melee = $"../MeleeAttack"
@onready var homingMissile = $"../HomingMissile"
@onready var laserBeam = $"../LaserBeam"
@onready var idle = $"../Idle"
@onready var playerDetectionZone = $"../../PlayerDetection"

func Enter():
	animation_player.play("idle")

func Physics(delta : float) -> EnemyState:
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
	
	var distance = owner.direction.length()

	accelerate_towards_point(enemy.playerPosition, delta)
		
	if distance > 50:
		attackPlayerRanged()
		pass
	else:
		return melee
		pass
		
	enemy.move_and_slide()
	return null
	
func attackPlayerRanged():
	var chance = randi() % 2
	match chance:
		0:
			StateMachine.ChangeState(homingMissile)
		1:
			StateMachine.ChangeState(laserBeam)
			
func accelerate_towards_point(point, delta):
	var direction = (point - enemy.global_position).normalized()
	enemy.velocity = enemy.velocity.move_toward(direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)
