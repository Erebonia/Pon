extends EnemyState
class_name Enemy_Follow

@onready var follow = $"../Follow"
@onready var melee = $"../MeleeAttack"
@onready var idle = $"../Idle"
@onready var playerDetectionZone = $"../../PlayerDetection"
@onready var softCollision = $SoftCollision

func Physics(delta : float) -> EnemyState:
	
	var distance = owner.direction.length()

	#if softCollision.is_colliding():
		#enemy.velocity += softCollision.get_push_vector() * delta * 400
		
	if distance <= 5:
		return melee
	
	return null
			
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	enemy.velocity = enemy.velocity.move_toward(direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)


func _on_player_detection_body_entered(body, delta):
	if body.has_method("player"):
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
		accelerate_towards_point(player.global_position, delta)
		enemy.move_and_slide()
