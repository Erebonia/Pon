extends State
class_name State_Attack

@onready var attack_combo = $"../Attack_Combo"
@onready var run = $"../Run"
@onready var idle = $"../Idle"
var bonusDMG = 0

func Enter():
	player.animationTree.set("parameters/Attack/blend_position", player.aim_direction)
	player.swordSprite.visible = true
	Status.KNOCKOUT_SPEED = 75
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack")
	player.attackTimer.start()

func Exit() -> void:
	pass

func Process(_delta : float) -> State:
	# Simple process loop that does nothing for now
	return null

func Physics(_delta : float) -> State:
	return null

func _on_attack_timer_timeout():
	state_machine.current_state = idle

func attack_animation_finished():
	if Input.is_action_just_pressed("attack"):
		state_machine.current_state = attack_combo
