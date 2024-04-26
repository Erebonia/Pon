extends EnemyState

var can_transition: bool = false
@export var DASH_SPEED = 0.4
@onready var melee = $"../MeleeAttack"

func Enter():
	animation_player.play("glowing")
	dash()

func Exit():
	pass

func dash():
	print("Attempting to dash towards player at: ")
	var tween = create_tween()
	if player != null:
		tween.tween_property(owner, "position", player.global_position, DASH_SPEED)  # Ensure using global_position if needed
		tween.connect("tween_completed", Callable(self, "_on_Tween_completed"))

func _on_Tween_completed(tween, property):
	can_transition = true
	StateMachine.ChangeState(melee)  # Directly call the state change here if appropriate

func Physics(_delta: float) -> EnemyState:
	# Now, can_transition might not be necessary unless you have other checks.
	if can_transition:
		can_transition = false
		return melee
	return null
