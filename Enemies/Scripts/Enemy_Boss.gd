extends Enemy_Base
class_name EnemyBoss

#General
@onready var boss_sprite = $Sprite2D
@onready var boss_healthbar = $UI/BossHealthbar
@onready var armor_buff = $FiniteStateMachine/ArmorBuff
 
func _ready():
	super._ready()
	boss_healthbar.max_value = stats.health
	boss_healthbar.init_health(stats.health)
 
func _physics_process(delta):
	debug.text = "State: " + state_machine.current_state.name
	
	if player != null:
		direction = player.global_position - global_position
		player_position = player.global_position
		
	if stats.health < 0:
		state_machine.ChangeState(death_state)
	
	if direction.x < 0:
		boss_sprite.flip_h = true
		melee_attack_dir.position.x = -31
	else:
		boss_sprite.flip_h = false
		melee_attack_dir.position.x = 17
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	
func _on_hurtbox_area_entered(area):
	if stats.health <= stats.max_health / 2  and stats.DEF == 0:  # Phase two of the fight he gets tankier
		stats.DEF = 5
		state_machine.ChangeState(armor_buff)
	
	if stats.health > 0:
		take_damage(area)
		healthbar.health = stats.health 
		boss_healthbar.health = stats.health 
	#Knockback
	var newDirection = ( position - area.owner.position ).normalized()
	var knockback = newDirection * player.player_data.KNOCKOUT_SPEED
	velocity = knockback

func _on_stats_no_health():
	state_machine.ChangeState(death_state)
	var enemyDeathEffect = Enemy_Death_Effect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
