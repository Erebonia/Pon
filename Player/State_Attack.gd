extends State
class_name State_Attack

@onready var attack_combo = $"../Attack_Combo"
@onready var run = $"../Run"
@onready var idle = $"../Idle"
var bonusDMG = 15
var attacking = false

func Enter():
	player.swordSprite.visible = true
	Status.KNOCKOUT_SPEED = 90
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack")
	player.attackTimer.start()
	player.animationTree.animation_finished.connect(endAttack)
	attacking = true
	
func Exit() -> void:
	player.animationTree.animation_finished.disconnect(endAttack)
	
func Process(_delta : float) -> State:
	return null

func Physics(_delta : float) -> State:
	player.velocity = Vector2.ZERO

	if Input.is_action_just_pressed("attack"):
		return attack_combo
	if !attacking:
		return idle
	
	return null
	
func _on_attack_timer_timeout():
	state_machine.ChangeState(idle)
	pass
	
func endAttack(_newAnimName : String):
	#When the signal ends we end the attack.
	attacking = false

