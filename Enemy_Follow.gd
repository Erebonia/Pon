extends EnemyState

signal knockback
 
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")
 
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func _physics_process(delta):
		if player != null:
			print("HI")
			#player.direction = player.position - player.position
 
func transition():
	var distance = owner.direction.length()
	get_parent().change_state("MeleeAttack")
	if distance > 50:
		attackPlayerRanged()

func attackPlayerRanged():
	#randomize the attacks
	var chance = randi() % 2
	match chance:
		0:
			get_parent().change_state("HomingMissile")
		1:
			get_parent().change_state("LaserBeam")


