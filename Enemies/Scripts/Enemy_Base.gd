extends CharacterBody2D
class_name Enemy_Base

const Enemy_Death_Effect = preload("res://Effects/Scenes/enemy_death_effect.tscn")

#Combat
@onready var stats = $Stats
@onready var hurtbox = $Hurtbox
@onready var melee_attack_dir = $FiniteStateMachine/MeleeAttack/MeleeAOE
@onready var healthbar = $Healthbar
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var blink_animation_player = $BlinkAnimationPlayer
@onready var soft_collision = $SoftCollision
@onready var death_state = $FiniteStateMachine/Death

#Direction
var direction : Vector2
var player_position
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200
@onready var start_position = get_global_transform().origin

var player

#Debug
@onready var debug = $Debug
@onready var state_machine = $FiniteStateMachine
 
func _ready():
	state_machine.Initialize(self)
	stats.connect("no_health", Callable(self, "_on_stats_no_health"))
	healthbar.max_value = stats.health
	player = get_tree().get_first_node_in_group("Player")
	healthbar.init_health(stats.health)
 
func _physics_process(delta):
	debug.text = "State: " + state_machine.current_state.name
	
	if player != null:
		direction = player.global_position - global_position
		
	var sprite = $AnimatedSprite
	if direction.x < 0:
		sprite.flip_h = true
		melee_attack_dir.position.x = -31
	else:
		sprite.flip_h = false
		melee_attack_dir.position.x = 17
		
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta
 
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
	hurtbox.create_hit_effect(area.global_position)
	hurtbox.start_invincibility(0.4)
	DamageNumbers.display_number(damage_taken, damage_numbers_origin.global_position, is_critical)

func _on_hurtbox_area_entered(area):
	if stats.health > 0:
		take_damage(area)
		healthbar.health = stats.health 
		
	#Knockback
	var newDirection = ( position - area.owner.position ).normalized()
	var knockback = newDirection * player.player_data.KNOCKOUT_SPEED
	velocity = knockback
	
func _on_hurtbox_invincibility_started():
	blink_animation_player.play("Start")

func _on_hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
	
func _on_stats_no_health():
	state_machine.ChangeState(death_state)
	var enemyDeathEffect = Enemy_Death_Effect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()
	
