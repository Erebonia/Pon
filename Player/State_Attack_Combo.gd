extends State
class_name State_Attack_Combo

@onready var run = $"../Run"
@onready var attack_combo2 = $"../Attack_Combo2"

var bonusDMG = 4

func Enter():
	if player.attackTimer.is_stopped():
		player.attackTimer.start()
		
	player.swordSprite.visible = true
	player.attackTimer.stop()
	Status.KNOCKOUT_SPEED = 80
	player.calculateDmg(bonusDMG)
	player.slashFX.play("slash_animation")
	player.UpdateAnimation("Attack_Combo")
	
func Exit():
	pass
	
func Physics( _delta : float) -> State:
	
	player.velocity = Vector2.ZERO

	return null

func attack_combo_animation_finished():
	pass
