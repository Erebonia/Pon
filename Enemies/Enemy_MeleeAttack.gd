extends EnemyState
 
func enter():
	super.enter()
	animation_player.speed_scale = 2
	animation_player.play("melee_attack")
	await animation_player.animation_finished
	animation_player.speed_scale = 1
 
func transition():
	if owner.direction.length() > 50:
		get_parent().change_state("Follow")
