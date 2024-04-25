extends State
class_name State_Attack_Combo2

@onready var run = $"../Run"
@onready var idle = $"../Idle"

var bonusDMG = 10

func Enter():
	if player.attackTimer.is_stopped(): 
		player.attackTimer.start()
	player.animationTree.set("parameters/Attack_Combo2/BlendSpace2D/blend_position", player.aim_direction)
	player.swordSprite.visible = true
	player.attackTimer.stop()
	Status.KNOCKOUT_SPEED = 100
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack_Combo2")
	player.attackTimer.start()
func Exit():
	pass
	
func Physics( _delta : float) -> State:
	
	return null
	
