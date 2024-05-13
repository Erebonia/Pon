extends State
class_name State_Attack_Combo

@onready var idle = $"../Idle"

var bonusDMG = 20
var attackComboCompleted = false
var attacking = false

func Enter():
	player.animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
	player.attackTimer.stop()
	Status.KNOCKOUT_SPEED = 90
	player.calculateDmg(bonusDMG)
	player.UpdateAnimation("Attack_Combo")
	player.animationTree.animation_finished.connect(endAttack)
	attacking = true
	
func Exit():
	player.animationTree.animation_finished.disconnect(endAttack)
	
func Physics( _delta : float) -> State:
	player.velocity = Vector2.ZERO
	
	if attackComboCompleted:
		attackComboCompleted = false
		return idle

	return null

func attack_combo_animation_finished():
	attackComboCompleted = true
	
func endAttack(_newAnimName : String):
	#When the signal ends we end the attack.
	attacking = false
