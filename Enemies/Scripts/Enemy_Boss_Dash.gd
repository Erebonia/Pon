extends EnemyState
 
@export var DASH_SPEED : int = 0.8
@onready var follow : Node2D = $"../Follow"
@onready var dash : Node2D = $"../Dash"
 
func Enter():
	animation_player.play("glowing")
	var tween = create_tween()
	tween.tween_property(owner, "position", enemy.playerPosition, DASH_SPEED)
	await tween.finished
 
func Physics(_delta : float) -> EnemyState:
	if owner.direction.length() < 30:
		return follow
		
	return follow
