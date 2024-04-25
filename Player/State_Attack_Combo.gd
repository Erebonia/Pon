extends State
class_name State_Attack_Combo

@onready var run = $"../Run"
@onready var attack_combo2 = $"../Attack_Combo2"

var bonusDMG = 4
var attacking = false

func Enter():
	player.animationTree.set("parameters/Attack_Combo/BlendSpace2D/blend_position", player.aim_direction)
	if player.attackTimer.is_stopped():
		player.attackTimer.start()
	player.swordSprite.visible = true
	player.attackTimer.stop()
	Status.KNOCKOUT_SPEED = 80
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack_Combo")
	attacking = true
	
func Exit():
	pass
	
func Physics( _delta : float) -> State:
	
	player.velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		return attack_combo2
	elif Input.is_action_just_pressed("Move_Right") or Input.is_action_just_pressed("Move_Left") or Input.is_action_just_pressed("Move_Down") or Input.is_action_just_pressed("Move_Up") or Input.is_action_pressed("Move_Down") or Input.is_action_pressed("Move_Right") or Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Up"):
		if attacking == false:
			return run

	return null

func attack_combo_animation_finished():
	attacking = false
	
