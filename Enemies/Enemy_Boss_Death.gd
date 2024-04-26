extends Enemy_Death

func Enter():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = enemy.global_position
	animation_player.play("death")
	await animation_player.animation_finished
	animation_player.play("boss_slain")
	Status.current_xp += 240
