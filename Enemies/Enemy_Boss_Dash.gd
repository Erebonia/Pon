extends EnemyState
 
@export var DASH_SPEED = 0.8
@onready var follow = $"../Follow"
@onready var dash = $"../Dash"
 
func Enter():
	print("DASH TIME")
	animation_player.play("glowing")
	var tween = create_tween()
	tween.tween_property(owner, "position", enemy.player.position, DASH_SPEED)
	await tween.finished
 
func Physics(_delta : float) -> EnemyState:
	if owner.direction.length() < 30:
		return follow
		
	return follow
