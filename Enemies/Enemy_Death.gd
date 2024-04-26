extends EnemyState
 
@onready var stats = owner.get_parent().find_child("Stats")

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

func enter():
	super.enter()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	animation_player.play("death")
	await animation_player.animation_finished
	animation_player.play("boss_slain")
	Status.current_xp += 240
