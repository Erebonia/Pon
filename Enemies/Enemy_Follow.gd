extends EnemyState
class_name Enemy_Follow

@onready var follow = $"../Follow"
@onready var melee = $"../MeleeAttack"
@onready var idle = $"../Idle"
@onready var playerDetectionZone = $"../../PlayerDetection"

func Physics(delta : float) -> EnemyState:
	#enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
	
	var distance = owner.direction.length()
	
	accelerate_towards_point(enemy.playerPosition, delta)
		
	if distance <= 5:
		return melee
		
	enemy.move_and_slide()
	return null
			
func accelerate_towards_point(point, delta):
	var direction = (point - enemy.global_position).normalized()
	enemy.velocity = enemy.velocity.move_toward(direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)
