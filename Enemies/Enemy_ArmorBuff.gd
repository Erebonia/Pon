extends EnemyState
 
var can_transition : bool = false
@onready var follow = $"../Follow"
@onready var canAttackBossCollision = $"../../Hurtbox/CollisionShape2D"

func Enter():
	animation_player.speed_scale = 0.8
	canAttackBossCollision.set_deferred("disabled", true)
	animation_player.play("armor_buff")
	await animation_player.animation_finished
	can_transition = true
	animation_player.speed_scale = 1
	
func Exit():
	pass
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		canAttackBossCollision.set_deferred("disabled", false)
		return follow
		
	return null
