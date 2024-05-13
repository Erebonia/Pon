extends Enemy_Base
class_name EnemyBoss

#General
@onready var bossSprite = $Sprite2D
@onready var bossHealthbar = $UI/BossHealthbar
@onready var armorBuff = $FiniteStateMachine/ArmorBuff
 
func _ready():
	super._ready()
	bossHealthbar.max_value = stats.health
	bossHealthbar.init_health(stats.health)
 
func _physics_process(delta):
	debug.text = "State: " + stateMachine.current_state.name
	
	if player != null:
		direction = player.global_position - global_position
		playerPosition = player.global_position
		
	if stats.health < 0:
		stateMachine.ChangeState(deathState)
	
	if direction.x < 0:
		bossSprite.flip_h = true
		meleeAttackDir.position.x = -31
	else:
		bossSprite.flip_h = false
		meleeAttackDir.position.x = 17
		
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	
func _on_hurtbox_area_entered(area):
	if stats.health <= stats.max_health / 2  and stats.DEF == 0:  # Phase two of the fight he gets tankier
		stats.DEF = 5
		stateMachine.ChangeState(armorBuff)
	
	if stats.health > 0:
		take_damage(area)
		healthbar.health = stats.health 
		bossHealthbar.health = stats.health 
	#Knockback
	var newDirection = ( position - area.owner.position ).normalized()
	var knockback = newDirection * player.stats.KNOCKOUT_SPEED
	velocity = knockback

func _on_stats_no_health():
	stateMachine.ChangeState(deathState)
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
