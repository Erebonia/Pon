extends EnemyState
class_name Enemy_Idle

@export var WANDER_TARGET_RANGE = 4
@onready var collision : CollisionShape2D = $"../../PlayerDetection/CollisionShape2D"
@onready var overhead_health_bar : ProgressBar = owner.find_child("Healthbar")
@onready var wander_controller : Node2D = $"../../WanderController"
@onready var follow : Node2D = $"../Follow"
@onready var idle : Node2D = $"../Idle"

enum {
	IDLE,
	WANDER
}

var state = IDLE
 
var player_entered: bool = false:
	set(value):
		player_entered = value
		
func Enter():
	state = pick_random_state([IDLE, WANDER])
		
func Physics(delta : float) -> EnemyState:
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
	
	match state:
		IDLE:
			enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.FRICTION * delta)
			if wander_controller.get_time_left() == 0:
				update_wander()
		WANDER:
			if wander_controller.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wander_controller.target_position, delta)
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
	
	if player_entered:
		return follow
	
	enemy.move_and_slide()
	
	return null
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(randf_range(1,3))
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	enemy.velocity = enemy.velocity.move_toward(direction * enemy.MAX_SPEED, enemy.ACCELERATION * delta)

func _on_player_detection_body_entered(body):
	if body is Player:
		player_entered = true

func _on_stats_health_changed(value):
	overhead_health_bar.set_deferred("visible",value)
