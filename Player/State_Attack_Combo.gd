extends State
class_name State_Attack_Combo

@onready var idle = $"../Idle"

var bonus_dmg = 20
var attack_combo_complete = false
var attacking = false

func Enter():
	player.animation_tree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
	player.attack_timer.stop()
	player.player_data.KNOCKOUT_SPEED = 90
	player.calculateDmg(bonus_dmg)
	player.UpdateAnimation("Attack_Combo")
	player.animation_tree.animation_finished.connect(endAttack)
	attacking = true
	
func Exit():
	player.animation_tree.animation_finished.disconnect(endAttack)
	
func Physics( _delta : float) -> State:
	player.velocity = Vector2.ZERO
	
	if attack_combo_complete:
		attack_combo_complete = false
		return idle

	return null

func attack_combo_animation_finished():
	attack_combo_complete = true
	
func endAttack(_newAnimName : String):
	#When the signal ends we end the attack.
	attacking = false
