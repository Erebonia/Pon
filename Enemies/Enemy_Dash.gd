extends EnemyState
 
var can_transition: bool = false
@export var DASH_SPEED = 0.4
@onready var follow = $"../Follow"
 
func Enter():
	animation_player.play("glowing")
	var tween = create_tween()
	tween.tween_property(owner, "position", enemy.player.position, DASH_SPEED)
	await tween.finished
	can_transition = true
	animation_player.animation_finished.connect(endDash)
	
func Exit():
	animation_player.animation_finished.disconnect(endDash)
 
func Physics(_delta : float) -> EnemyState:
	if can_transition and owner.direction.length() > 30:
		can_transition = false
		return follow
		
	return null

func endDash(_newAnimName : String):
	can_transition = true
