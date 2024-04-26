extends EnemyState

@export var WANDER_TARGET_RANGE = 4
@onready var collision = $"../../PlayerDetection/CollisionShape2D"
@onready var progress_bar = owner.find_child("BossHealthbar")
@onready var overhead_health_bar = owner.find_child("Healthbar")
@onready var canAttackBossCollision = $"../../Hurtbox/CollisionShape2D"
@onready var playerDetectionZone = $"../../PlayerDetection"
@onready var wanderController = $"../../WanderController"
@onready var follow = $"../Follow"
@onready var idle = $"../Idle"

enum {
	IDLE,
	WANDER
}

var state = IDLE
 
var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		canAttackBossCollision.set_deferred("disabled", false)
		progress_bar.set_deferred("visible",value)
		overhead_health_bar.set_deferred("visible",value)
		
func Enter():
	state = pick_random_state([IDLE, WANDER])
		
func Physics(delta : float) -> EnemyState:
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
	
	match state:
		IDLE:
			enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
	
	if player_entered:
		return follow
	
	enemy.move_and_slide()
	
	return null
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randf_range(1,3))
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func accelerate_towards_point(point, delta):
	var direction = (point - enemy.global_position).normalized()
	enemy.velocity = enemy.velocity.move_toward(direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)


func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		player_entered = true
		
func _on_player_detection_body_exited(body):
	if body.has_method("player"):
		StateMachine.ChangeState(idle)
