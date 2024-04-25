extends State
class_name State_Attack

@onready var attack_combo = $"../Attack_Combo"
@onready var run = $"../Run"
@onready var idle = $"../Idle"
var bonusDMG = 0

# New flag to indicate if the attack is active
var is_attacking = false

func Enter():
	player.swordSprite.visible = true
	Status.KNOCKOUT_SPEED = 75
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack")
	player.attackTimer.start()
	is_attacking = true  # Attack starts
	
func Exit() -> void:
	is_attacking = false  # Reset when exiting state

func Process(_delta : float) -> State:
	return null

func Physics(_delta : float) -> State:
	player.velocity = Vector2.ZERO
	
	# Prevent transition to run state if attack is active
	if not is_attacking:
		if Input.is_action_just_pressed("Move_Right") or Input.is_action_just_pressed("Move_Left") or Input.is_action_just_pressed("Move_Down") or Input.is_action_just_pressed("Move_Up") or Input.is_action_pressed("Move_Down") or Input.is_action_pressed("Move_Right") or Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Up"):
			return run
		
	return null
	
func _on_attack_timer_timeout():
	is_attacking = false  # Attack ends when timer times out
	state_machine.current_state = idle

func attack_animation_finished():
	is_attacking = false  # Ensure attack is marked as finished
