extends EnemyState
 
var can_transition : bool = false
@onready var follow = $"../Follow"
@onready var can_attack_boss_collision = $"../../Hurtbox/CollisionShape2D"

func Enter():
	animation_player.speed_scale = 0.8
	can_attack_boss_collision.set_deferred("disabled", true)
	animation_player.play("block")
	await animation_player.animation_finished
	animation_player.play("armor_buff")
	await animation_player.animation_finished
	can_transition = true
	animation_player.speed_scale = 1
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		can_attack_boss_collision.set_deferred("disabled", false)
		return follow
		
	return null
