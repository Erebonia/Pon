extends State
 
func enter():
	super.enter()
	animation_player.speed_scale = 2
	animation_player.play("melee_attack")
	animation_player.animation_finished
	animation_player.speed_scale = 1
 
func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
