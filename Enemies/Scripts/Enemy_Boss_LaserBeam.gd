extends EnemyState
 
@onready var pivot : Node2D = $"../../pivot"
@onready var dash : Node2D = $"../Dash"
@onready var follow : Node2D = $"../Follow"

var can_transition: bool = false
 
func Enter():
	animation_player.speed_scale = 1
	await play_animation("laser_cast")
	animation_player.speed_scale = 1
	await play_animation("laser")
	can_transition = true
 
func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished
 
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		return follow
	return null
