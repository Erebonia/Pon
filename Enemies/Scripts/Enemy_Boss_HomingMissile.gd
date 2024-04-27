extends EnemyState
 
@export var bullet_node: PackedScene
var can_transition: bool = false
@onready var follow = $"../Follow"
 
func Enter():
	animation_player.speed_scale = 0.75
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	animation_player.speed_scale = 1
	shoot()
	can_transition = true
 
func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)
 
func Physics(_delta : float) -> EnemyState:
	if can_transition:
		can_transition = false
		return follow
		
	return null
