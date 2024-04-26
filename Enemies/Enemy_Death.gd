extends EnemyState
class_name Enemy_Death
 
@onready var stats = owner.get_parent().find_child("Stats")

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

func Enter():
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = enemy.global_position
	Status.current_xp += 240
	enemy.queue.free()
