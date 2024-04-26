extends EnemyState
 
var can_transition: bool = false
@export var DASH_SPEED = 0.4
@onready var melee = $"../MeleeAttack"
 
func Enter():
	animation_player.play("glowing")
	await dash()
	can_transition = true
	
func Exit():
	pass
 
func dash():
	var tween = create_tween()
	if player != null:
		tween.tween_property(owner, "position", player.position, DASH_SPEED)
		await tween.finished
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		return melee
	return null
