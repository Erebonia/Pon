extends CharacterBody2D
class_name Enemy_Base

const EnemyDeathEffect = preload("res://Effects/Scenes/enemy_death_effect.tscn")

#Combat
@onready var stats = $Stats
@onready var hurtbox = $Hurtbox
@onready var meleeAttackDir = $FiniteStateMachine/MeleeAttack/MeleeAOE
@onready var healthbar = $Healthbar
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var softCollision = $SoftCollision
@onready var deathState = $FiniteStateMachine/Death

#Direction
var direction : Vector2
var playerPosition
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200
@onready var startPosition = get_global_transform().origin
@onready var player = get_parent().find_child("Player")

#Debug
@onready var debug = $Debug
@onready var stateMachine = $FiniteStateMachine
 
func _ready():
	stateMachine.Initialize(self)
	stats.connect("no_health", Callable(self, "_on_stats_no_health"))
	healthbar.max_value = stats.health
	#healthbar.init_health(stats.health)  # Corrected function name
 
func _physics_process(delta):
	debug.text = "State: " + stateMachine.current_state.name
	
	if player != null:
		direction = player.position - position
		playerPosition = player.position
		
	var sprite = $AnimatedSprite
	if direction.x < 0:
		sprite.flip_h = true
		meleeAttackDir.position.x = -31
	else:
		sprite.flip_h = false
		meleeAttackDir.position.x = 17
		
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta
 
func take_damage(area):
	var is_critical = false
	var damage_taken

	if area.damage - stats.DEF > 0:
		damage_taken = (area.damage - stats.DEF)
	else:
		damage_taken = area.damage

	var critical_chance = randf()

	if critical_chance <= 0.10:
		is_critical = true
		var critical_multiplier = randf_range(1.5, 2)
		damage_taken *= critical_multiplier

	stats.health -= damage_taken
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	DamageNumbers.display_number(damage_taken, damage_numbers_origin.global_position, is_critical)

func _on_hurtbox_area_entered(area):
	if stats.health > 0:
		take_damage(area)
		healthbar.health = stats.health 
		
	#Knockback
	var newDirection = ( position - area.owner.position ).normalized()
	var knockback = newDirection * Status.KNOCKOUT_SPEED
	velocity = knockback
	
func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
	
func _on_stats_no_health():
	stateMachine.ChangeState(deathState)
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()
	
